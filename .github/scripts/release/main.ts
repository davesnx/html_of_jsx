#!/usr/bin/env node

import * as core from '@actions/core';
import * as github from '@actions/github';
import { execSync } from 'child_process';
import Fs from 'fs';
import Path from 'path';
import OS from 'os';

interface ReleaseConfig {
  user: string;
  remote: string;
  local: string;
}

interface GitHubContext {
  ref: string;
  repository: string;
  workspace: string;
  token: string;
}

class ReleaseManager {
  private context: GitHubContext;
  private verbose: boolean;

  constructor(context: GitHubContext, verbose: boolean = false) {
    this.context = context;
    this.verbose = verbose;
  }

  /**
   * Conditional info logging - only logs if verbose mode is enabled
   */
  private info(message: string): void {
    if (this.verbose) {
      core.info(message);
    }
  }

  /**
   * Execute a command and return its output
   */
  private exec(command: string, options: { silent?: boolean } = {}): string {
    if (!options.silent) {
      this.info(`> ${command}`);
    }

    try {
      const result = execSync(command, {
        encoding: 'utf-8',
        // Use 'ignore' for stdin to avoid TTY errors in CI, inherit stdout/stderr for visibility
        stdio: options.silent ? 'pipe' : ['ignore', 'inherit', 'inherit']
      });

      // When stdio is 'inherit', execSync returns null
      // When stdio is 'pipe', it returns the output
      if (result === null || result === undefined) {
        return '';
      }

      return result.toString().trim();
    } catch (error: any) {
      const message = `Command failed: ${command}\n${error.message}`;
      core.error(message);
      throw new Error(message);
    }
  }

  /**
   * Extract version from git tag
   */
  private extractVersion(): string {
    try {
      const tag = this.context.ref.replace('refs/tags/', '');
      if (!tag || tag === this.context.ref) {
        throw new Error('No valid git tag found in ref');
      }
      core.setOutput('version', tag);
      this.info(`Extracted version: ${tag}`);
      return tag;
    } catch (error: any) {
      core.error(`Failed to extract version from ref ${this.context.ref}: ${error.message}`);
      throw new Error(`Could not extract version: ${error.message}`);
    }
  }

  /**
   * Configure Git for release operations
   */
  private configureGit(): void {
    core.startGroup('Configuring Git for release');

    try {
      this.exec('git config --global user.name "GitHub Actions"');
      this.exec('git config --global user.email "actions@github.com"');

      // Configure git to use token for SSH-style URLs
      const gitConfig = `https://x-access-token:${this.context.token}@github.com/`;
      this.exec(`git config --global url."${gitConfig}".insteadOf "git@github.com:"`);

      this.info('Git configuration completed');
    } catch (error: any) {
      core.error(`Failed to configure git: ${error.message}`);
      throw new Error(`Could not configure git: ${error.message}`);
    }

    core.endGroup();
  }

  /**
   * Setup dune-release configuration
   */
  private setupDuneReleaseConfig(config: ReleaseConfig): void {
    core.startGroup('Setting up dune-release configuration');

    try {
      const configDir = Path.join(OS.homedir(), '.config', 'dune');
      Fs.mkdirSync(configDir, { recursive: true });

      const configContent = `user: ${config.user}
remote: ${config.remote}
local: ${config.local}
`;

      Fs.writeFileSync(Path.join(configDir, 'release.yml'), configContent);

      // Create GitHub token file with secure permissions
      const tokenPath = Path.join(configDir, 'github.token');
      Fs.writeFileSync(tokenPath, this.context.token, { mode: 0o600 });
      this.info(`GitHub token file created at ${tokenPath}`);

      this.info('dune-release configuration created');
    } catch (error: any) {
      core.error(`Failed to setup dune-release configuration: ${error.message}`);
      throw new Error(`Could not setup dune-release configuration: ${error.message}`);
    }

    core.endGroup();
  }

  /**
   * Clone opam-repository fork and sync with upstream
   */
  private cloneOpamRepository(forkUrl: string, localPath: string): void {
    core.startGroup('Cloning opam-repository fork');

    // Create directory structure
    const gitDir = Path.dirname(localPath);
    try {
      Fs.mkdirSync(gitDir, { recursive: true });
      this.info(`Created directory: ${gitDir}`);
    } catch (error: any) {
      core.warning(`Could not create directory ${gitDir}: ${error.message}`);
      // Try to proceed anyway, git clone might handle it
    }

    // Clone fork with shallow depth for faster cloning
    this.exec(`git clone --depth 1 ${forkUrl} ${localPath}`);

    // Set up upstream and sync
    const originalDir = process.cwd();
    try {
      try {
        process.chdir(localPath);
      } catch (error: any) {
        core.error(`Failed to change to cloned repository directory: ${error.message}`);
        throw new Error(`Could not change to directory ${localPath}: ${error.message}`);
      }

      // Add upstream remote
      try {
        this.exec('git remote add upstream https://github.com/ocaml/opam-repository.git');
      } catch {
        this.info('Upstream remote already exists');
      }

      // Fetch and merge latest from upstream (shallow fetch)
      this.exec('git fetch --depth 1 upstream master');
      this.exec('git checkout master');

      try {
        this.exec('git merge upstream/master --ff-only');
        this.info('Fork synced with upstream');
      } catch {
        core.warning('Your fork may be out of sync with upstream');
      }
    } finally {
      process.chdir(originalDir);
    }
    core.endGroup();
  }

  /**
   * Run dune-release commands
   */
  private runDuneRelease(command: string, args: string[] = []): void {
    const fullCommand = `opam exec -- dune-release ${command} ${args.join(' ')}`;
    this.exec(fullCommand);
  }

  /**
   * Delete tag on failure
   */
  private deleteTag(): void {
    const tagName = this.context.ref.replace('refs/tags/', '');
    core.error(`Release failed, deleting tag ${tagName}`);

    // Configure git with token
    const gitConfig = `https://x-access-token:${this.context.token}@github.com/`;
    this.exec(`git config --global url."${gitConfig}".insteadOf "https://github.com/"`, { silent: true });

    // Delete remote tag
    try {
      this.exec(`git push origin --delete ${tagName}`);
      this.info(`Remote tag ${tagName} deleted`);
    } catch {
      core.warning(`Failed to delete remote tag ${tagName}`);
    }

    // Delete local tag
    try {
      this.exec(`git tag -d ${tagName}`, { silent: true });
      this.info(`Local tag ${tagName} deleted`);
    } catch {
      // Ignore error for local tag deletion
    }

    core.error(`Release failed - tag ${tagName} has been deleted. Please fix the issues and create a new tag.`);
    process.exit(1);
  }

  /**
   * Run the full release pipeline
   */
  async runRelease(
    packageName: string,
    changelogPath: string,
    duneConfig: ReleaseConfig,
    dryRun: boolean
  ): Promise<void> {
    try {
      // Setup
      this.configureGit();
      const version = this.extractVersion();

      if (dryRun) {
        core.warning('🔧 DRY RUN MODE ENABLED - No actual submission to opam-repository will occur');
      }

      this.info(`Starting release for version ${version}`);

      // Lint opam files
      core.startGroup('Linting opam files');
      this.runDuneRelease('lint');
      core.endGroup();

      // Setup dune-release config
      this.setupDuneReleaseConfig(duneConfig);

      // Clone opam repository (even in dry-run to validate the setup)
      this.cloneOpamRepository(duneConfig.remote, duneConfig.local);

      // Distribute release archive
      core.startGroup('Distributing release archive');
      this.runDuneRelease('distrib', ['--skip-tests', '--skip-lint']);
      core.endGroup();

      // Publish to GitHub
      core.startGroup('Publishing to GitHub');
      process.env.DUNE_RELEASE_DELEGATE = 'github-dune-release';
      process.env.GITHUB_TOKEN = this.context.token;
      this.runDuneRelease('publish', ['--yes', `--change-log=${changelogPath}`]);
      core.endGroup();

      // Package opam release
      core.startGroup(`Packaging opam release for ${packageName}`);
      this.runDuneRelease('opam', ['pkg', '-p', packageName, '--yes', `--change-log=${changelogPath}`]);
      core.endGroup();

      // Submit to opam repository (or skip if dry-run)
      if (dryRun) {
        core.startGroup('Submitting to opam repository (DRY RUN - skipping actual submission)');
        core.warning('DRY RUN: Skipping actual submission to opam-repository');
        this.info('In a real release, this would submit a PR to the opam-repository');
        core.endGroup();
      } else {
        core.startGroup('Submitting to opam repository');
        process.env.DUNE_RELEASE_DELEGATE = 'github-dune-release';
        process.env.GITHUB_TOKEN = this.context.token;
        // Ensure we're in the project directory
        try {
          process.chdir(this.context.workspace);
        } catch (error: any) {
          core.error(`Failed to change to workspace directory: ${error.message}`);
          throw new Error(`Could not change to workspace directory ${this.context.workspace}: ${error.message}`);
        }
        this.runDuneRelease('opam', ['submit', '--yes', `--change-log=${changelogPath}`]);
        core.endGroup();
      }

      // Success notification
      if (dryRun) {
        core.notice(`DRY RUN: Release ${version} completed successfully (no PR was submitted)! 🎭`);
      } else {
        const tagName = this.context.ref.replace('refs/tags/', '');
        core.notice(`Release ${tagName} completed successfully! 🎉`);
        this.info('Next steps:');
        this.info(`1. Check the GitHub release: https://github.com/${this.context.repository}/releases/tag/${tagName}`);
        this.info('2. Monitor the opam PR for approval');
      }

    } catch (error: any) {
      core.error(`Release failed: ${error.message}`);
      if (!dryRun) {
        this.deleteTag();
      } else {
        core.warning('DRY RUN: Would delete tag on failure in real release');
      }
      throw error;
    }
  }
}

async function main() {
  try {
    const packageName = core.getInput('package-name', { required: true });
    const changelogPath = core.getInput('changelog') || './CHANGES.md';
    const token = core.getInput('github-token', { required: true });
    const dryRun = core.getInput('dry-run') === 'true';
    const verbose = core.getInput('verbose') === 'true';

    // Get the user's GitHub username for the opam-repository fork
    const effectiveUser = process.env.GITHUB_ACTOR || 'github-actions';
    const opamRepoFork = `${effectiveUser}/opam-repository`;

    // Use a local path that works both on GitHub Actions and locally
    const defaultOpamPath = process.env.RUNNER_TEMP ? '/home/runner/git/opam-repository' : '/tmp/opam-repository-test';
    const opamRepoLocal = core.getInput('opam-repo-local') || defaultOpamPath;

    // Get context from environment and GitHub context
    // For PRs, use the temporary test tag instead of the PR ref
    let ref = process.env.GITHUB_REF || github.context.ref;
    if (ref.startsWith('refs/pull/')) {
      // This is a PR, use the temporary test tag from environment
      const testTag = process.env.TEST_TAG || '0.3.0-beta';
      ref = `refs/tags/${testTag}`;
      core.info(`Running on PR, using temporary test tag: ${ref}`);
    }

    const context: GitHubContext = {
      ref: ref,
      repository: process.env.GITHUB_REPOSITORY || `${github.context.repo.owner}/${github.context.repo.repo}`,
      workspace: process.env.GITHUB_WORKSPACE || process.cwd(),
      token: token
    };

    // Build dune-release config
    const duneConfig: ReleaseConfig = {
      user: effectiveUser,
      remote: `git@github.com:${opamRepoFork}`,
      local: opamRepoLocal
    };

    // Log configuration (only if verbose)
    if (verbose) {
      core.info('=== OCaml Dune Release Action ===');
      core.info(`Package: ${packageName}`);
      core.info(`Changelog: ${changelogPath}`);
      core.info(`User: ${effectiveUser}`);
      core.info(`Opam fork: ${opamRepoFork}`);
      if (dryRun) {
        core.info(`Mode: DRY RUN (no submission to opam-repository)`);
      } else {
        core.info(`Mode: FULL RELEASE`);
      }
      core.info('================================');
    }

    // Run the release
    const releaseManager = new ReleaseManager(context, verbose);
    await releaseManager.runRelease(packageName, changelogPath, duneConfig, dryRun);

    core.setOutput('release-status', 'success');
  } catch (error: any) {
    core.setFailed(error.message);
    core.setOutput('release-status', 'failed');
    process.exit(1);
  }
}

main();

export { ReleaseManager, ReleaseConfig, GitHubContext };
export default main;
