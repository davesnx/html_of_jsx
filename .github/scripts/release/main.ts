#!/usr/bin/env node

import * as core from '@actions/core';
import * as github from '@actions/github';
import { execSync } from 'child_process';
import Fs from 'fs';
import Path from 'path';
import OS from 'os';
import { validateChangelog, extractVersionChangelog } from './changelog';

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
   * Validate that the tag is new and doesn't exist on remote
   */
  private validateNewTag(): void {
    core.startGroup('Validating tag');

    try {
      const tagName = this.context.ref.replace('refs/tags/', '');
      this.info(`Checking if tag ${tagName} already exists on remote...`);

      const remoteTags = this.exec('git ls-remote --tags origin', { silent: true });
      const tagExists = remoteTags.includes(`refs/tags/${tagName}`);

      if (tagExists) {
        core.warning(`Tag ${tagName} already exists on remote repository`);
      } else {
        this.info(`Tag ${tagName} is new, proceeding with release`);
      }
    } catch (error: any) {
      core.warning(`Could not validate tag existence: ${error.message}`);
      this.info('Proceeding anyway (validation check failed)');
    }

    core.endGroup();
  }

  /**
   * Check if required tools are installed
   */
  private checkDependencies(): void {
    core.startGroup('Checking dependencies');

    const dependencies = [
      { name: 'opam', command: 'opam --version' },
      { name: 'dune-release', command: 'opam exec -- dune-release --version' }
    ];

    const missing: string[] = [];

    for (const dep of dependencies) {
      try {
        const version = this.exec(dep.command, { silent: true });
        this.info(`✓ ${dep.name} is installed: ${version}`);
      } catch (error: any) {
        core.error(`✗ ${dep.name} is not installed or not accessible`);
        missing.push(dep.name);
      }
    }

    core.endGroup();

    if (missing.length > 0) {
      const errorMessage = `Missing required dependencies: ${missing.join(', ')}`;
      core.error(errorMessage);
      core.error('');
      core.error('To fix this:');

      if (missing.includes('opam')) {
        core.error('Install opam: https://opam.ocaml.org/doc/Install.html');
      }

      if (missing.includes('dune-release')) {
        core.error('Install dune-release: opam install dune-release');
      }

      throw new Error(errorMessage);
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
    this.info(`Attempting to delete tag ${tagName}`);

    // Configure git with token
    const gitConfig = `https://x-access-token:${this.context.token}@github.com/`;
    this.exec(`git config --global url."${gitConfig}".insteadOf "https://github.com/"`, { silent: true });

    // Check if remote tag exists before deleting
    try {
      const remoteTags = this.exec('git ls-remote --tags origin', { silent: true });
      const remoteTagExists = remoteTags.includes(`refs/tags/${tagName}`);

      if (remoteTagExists) {
        this.exec(`git push origin --delete ${tagName}`);
        this.info(`Remote tag ${tagName} deleted`);
      } else {
        this.info(`Remote tag ${tagName} does not exist, skipping deletion`);
      }
    } catch (error: any) {
      core.warning(`Could not delete remote tag ${tagName}: ${error.message}`);
    }

    // Check if local tag exists before deleting
    try {
      const localTags = this.exec('git tag -l', { silent: true });
      const localTagExists = localTags.split('\n').includes(tagName);

      if (localTagExists) {
        this.exec(`git tag -d ${tagName}`, { silent: true });
        this.info(`Local tag ${tagName} deleted`);
      } else {
        this.info(`Local tag ${tagName} does not exist, skipping deletion`);
      }
    } catch (error: any) {
      core.warning(`Could not delete local tag ${tagName}: ${error.message}`);
    }

    core.error(`Release failed - tag cleanup completed. Please fix the issues and create a new tag.`);
    process.exit(1);
  }

  /**
   * Run the full release pipeline
   */
  async runRelease(
    packageName: string,
    changelogPath: string,
    duneConfig: ReleaseConfig,
    toGithubReleases: boolean,
    toOpamRepository: boolean
  ): Promise<void> {
    let versionChangelogPath: string | null = null;

    try {
      // Check dependencies first
      this.checkDependencies();

      // Validate the tag is new
      this.validateNewTag();

      // Setup
      this.configureGit();
      const version = this.extractVersion();

      // Log what will be published
      if (!toGithubReleases && !toOpamRepository) {
        core.warning('Both GitHub releases and opam submission are disabled - running validation only');
      } else {
        if (!toGithubReleases) {
          core.warning('GitHub releases disabled - will not publish to GitHub');
        }
        if (!toOpamRepository) {
          core.warning('opam submission disabled - will not submit to opam-repository');
        }
      }

      this.info(`Starting release for version ${version}`);

      // Validate and extract changelog
      core.startGroup('Validating changelog');
      const validation = validateChangelog(changelogPath, version);

      // Display warnings
      if (validation.warnings.length > 0) {
        validation.warnings.forEach(warning => core.warning(warning));
      }

      // Display errors and fail if invalid
      if (!validation.valid) {
        validation.errors.forEach(error => core.error(error));
        throw new Error('Changelog validation failed. Please fix the issues and try again.');
      }

      // Extract version-specific changelog to temporary file
      const changelogFilename = Path.basename(changelogPath, Path.extname(changelogPath));
      const absoluteChangelogPath = Path.resolve(changelogPath);
      versionChangelogPath = Path.join(
        Path.dirname(absoluteChangelogPath),
        `${changelogFilename}-${version}${Path.extname(changelogPath)}`
      );

      extractVersionChangelog(absoluteChangelogPath, version, versionChangelogPath);

      // Log the extracted content for verification
      try {
        const extractedContent = Fs.readFileSync(versionChangelogPath, 'utf-8');
        core.info(`Created version-specific changelog at: ${versionChangelogPath}`);
        core.info(`Changelog content (${extractedContent.length} chars):`);
        this.info(extractedContent.substring(0, 200) + (extractedContent.length > 200 ? '...' : ''));
      } catch (error: any) {
        core.warning(`Could not read version-specific changelog: ${error.message}`);
      }

      // Update changelogPath to use the version-specific file (absolute path)
      changelogPath = versionChangelogPath;

      core.endGroup();

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

      // Publish to GitHub (conditional)
      if (toGithubReleases) {
        core.startGroup('Publishing to GitHub');
        process.env.DUNE_RELEASE_DELEGATE = 'github-dune-release';
        process.env.GITHUB_TOKEN = this.context.token;
        this.info(`Publishing with changelog: ${changelogPath}`);
        this.runDuneRelease('publish', ['--yes', `--change-log=${changelogPath}`]);
        core.endGroup();
      } else {
        core.startGroup('Publishing to GitHub (skipped)');
        core.warning('Skipping GitHub release publication');
        core.endGroup();
      }

      // Package opam release (always needed for validation)
      core.startGroup(`Packaging opam release for ${packageName}`);
      this.runDuneRelease('opam', ['pkg', '-p', packageName, '--yes', `--change-log=${changelogPath}`]);
      core.endGroup();

      // Submit to opam repository (conditional)
      if (toOpamRepository) {
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
      } else {
        core.startGroup('Submitting to opam repository (skipped)');
        core.warning('Skipping submission to opam-repository');
        core.endGroup();
      }

      // Success notification
      const tagName = this.context.ref.replace('refs/tags/', '');
      core.notice(`Release ${tagName} completed successfully!`);

      if (toGithubReleases) {
        core.notice(`GitHub release: https://github.com/${this.context.repository}/releases/tag/${tagName}`);
      }

      if (toOpamRepository) {
        // Construct the expected opam PR URL
        const opamBranch = `release-${packageName}-${version}`;
        const effectiveUser = duneConfig.user;
        const opamPrUrl = `https://github.com/ocaml/opam-repository/compare/master...${effectiveUser}:opam-repository:${opamBranch}`;

        core.notice(`Opam PR: ${opamPrUrl}`);

        // Create a commit with the release information
        try {
          core.startGroup('Creating release tracking commit');

          let commitMessage = `release ${version}\n\n`;
          if (toOpamRepository) {
            commitMessage += `opam pr: ${opamPrUrl}\n`;
          }
          if (toGithubReleases) {
            commitMessage += `github release: https://github.com/${this.context.repository}/releases/tag/${tagName}\n`;
          }

          // Check if we're on a branch (not detached HEAD)
          const currentBranch = this.exec('git rev-parse --abbrev-ref HEAD', { silent: true });

          if (currentBranch === 'HEAD') {
            this.info('Running on detached HEAD (tag), skipping commit creation');
          } else {
            // Allow empty commit in case there are no changes
            this.exec(`git commit --allow-empty -m "${commitMessage.trim()}"`);
            this.info('Created commit with release information');

            // Push the commit to the repository
            this.exec(`git push origin ${currentBranch}`);
            this.info(`Pushed release tracking commit to ${currentBranch}`);
          }

          core.endGroup();
        } catch (error: any) {
          core.warning(`Could not create or push release tracking commit: ${error.message}`);
          // Non-fatal, continue
        }
      }

    } catch (error: any) {
      const errorMessage = error.message || error.toString();

      // Check for specific error patterns and provide helpful messages
      if (errorMessage.includes('without `workflow` scope')) {
        core.error('GitHub token is missing the "workflow" scope');
      } else if (errorMessage.includes('Permission to') && errorMessage.includes('denied')) {
        core.error('GitHub token does not have permission to push to the repository');
        core.error('Make sure your token has the "repo" scope and you have push access');
      } else if (errorMessage.includes('authentication failed') || errorMessage.includes('Invalid username or token')) {
        core.error('GitHub token authentication failed');
        core.error('Please check that your GH_TOKEN secret is valid and not expired');
      }

      core.error(`Release failed: ${errorMessage}`);

      // Only delete tag if we were publishing to GitHub (real release scenario)
      if (toGithubReleases || toOpamRepository) {
        this.deleteTag();
      } else {
        core.warning('Validation mode: Skipping tag deletion on failure');
      }
      throw error;
    } finally {
      // Clean up temporary changelog file
      if (versionChangelogPath && Fs.existsSync(versionChangelogPath)) {
        try {
          Fs.unlinkSync(versionChangelogPath);
          this.info(`Cleaned up temporary changelog: ${versionChangelogPath}`);
        } catch (error: any) {
          core.warning(`Could not clean up temporary changelog: ${error.message}`);
        }
      }
    }
  }
}

async function main() {
  try {
    const packageName = core.getInput('package-name', { required: true });
    const changelogPath = core.getInput('changelog') || './CHANGES.md';
    const token = core.getInput('github-token', { required: true });
    const toOpamRepository = core.getInput('to-opam-repository') !== 'false';
    const toGithubReleases = core.getInput('to-github-releases') !== 'false';
    const verbose = core.getInput('verbose') === 'true';

    // Validate that we're running on a tag
    // Use TEST_OVERRIDE_GITHUB_REF if provided (for testing), otherwise use GITHUB_REF
    const testRefOverride = process.env.TEST_OVERRIDE_GITHUB_REF || '';
    const ref = testRefOverride || process.env.GITHUB_REF || github.context.ref;
    if (!ref.startsWith('refs/tags/')) {
      throw new Error(`This action must be run on a git tag. Current ref: ${ref}`);
    }

    if (testRefOverride && verbose) {
      core.warning(`Using TEST_OVERRIDE_GITHUB_REF: ${testRefOverride}`);
    }

    // Get the user's GitHub username for the opam-repository fork
    const effectiveUser = process.env.GITHUB_ACTOR || 'github-actions';
    const opamRepoFork = `${effectiveUser}/opam-repository`;

    // Use a local path that works both on GitHub Actions and locally
    const defaultOpamPath = process.env.RUNNER_TEMP ? '/home/runner/git/opam-repository' : '/tmp/opam-repository-test';
    const opamRepoLocal = core.getInput('opam-repo-local') || defaultOpamPath;

    // Get context from environment and GitHub context
    const context: GitHubContext = {
      ref: ref, // Use the ref we already validated (includes test override)
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
      core.info(`Publish to GitHub: ${toGithubReleases ? 'Yes' : 'No'}`);
      core.info(`Submit to opam: ${toOpamRepository ? 'Yes' : 'No'}`);
      core.info('================================');
    }

    // Run the release
    const releaseManager = new ReleaseManager(context, verbose);
    await releaseManager.runRelease(packageName, changelogPath, duneConfig, toGithubReleases, toOpamRepository);

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
