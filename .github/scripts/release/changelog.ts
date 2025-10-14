import * as core from '@actions/core';
import Fs from 'fs';

export interface ChangelogEntry {
  version: string;
  date?: string;
  content: string;
}

export interface ChangelogValidation {
  valid: boolean;
  hasUnreleased: boolean;
  hasVersionEntry: boolean;
  versionContent?: string;
  warnings: string[];
  errors: string[];
}

/**
 * Parse a changelog file (Markdown format)
 * Supports formats like:
 * ## v1.0.0 (2025-01-13)
 * ## 1.0.0
 * # Unreleased
 */
export function parseChangelog(changelogPath: string): ChangelogEntry[] {
  try {
    const content = Fs.readFileSync(changelogPath, 'utf-8');
    const entries: ChangelogEntry[] = [];

    // Split by headers (## or #)
    const lines = content.split('\n');
    let currentEntry: ChangelogEntry | null = null;
    let currentContent: string[] = [];

    for (const line of lines) {
      // Match version headers: ## v1.0.0 or ## 1.0.0 or ## v1.0.0 (2025-01-13)
      const versionMatch = line.match(/^##\s+v?(\d+\.\d+\.\d+(?:-[a-zA-Z0-9.]+)?)\s*(?:\(([^)]+)\))?/);
      // Match unreleased header: # Unreleased or ## Unreleased
      const unreleasedMatch = line.match(/^#{1,2}\s+Unreleased/i);

      if (versionMatch || unreleasedMatch) {
        // Save previous entry if exists
        if (currentEntry) {
          currentEntry.content = currentContent.join('\n').trim();
          entries.push(currentEntry);
        }

        // Start new entry
        if (versionMatch) {
          currentEntry = {
            version: versionMatch[1],
            date: versionMatch[2],
            content: ''
          };
        } else if (unreleasedMatch) {
          currentEntry = {
            version: 'unreleased',
            content: ''
          };
        }
        currentContent = [];
      } else if (currentEntry) {
        // Add content to current entry
        currentContent.push(line);
      }
    }

    // Save last entry
    if (currentEntry) {
      currentEntry.content = currentContent.join('\n').trim();
      entries.push(currentEntry);
    }

    return entries;
  } catch (error: any) {
    throw new Error(`Failed to parse changelog: ${error.message}`);
  }
}

/**
 * Validate changelog for a specific version
 */
export function validateChangelog(
  changelogPath: string,
  expectedVersion: string
): ChangelogValidation {
  const validation: ChangelogValidation = {
    valid: true,
    hasUnreleased: false,
    hasVersionEntry: false,
    warnings: [],
    errors: []
  };

  try {
    // Check if file exists
    if (!Fs.existsSync(changelogPath)) {
      validation.valid = false;
      validation.errors.push(`Changelog file not found: ${changelogPath}`);
      return validation;
    }

    // Parse changelog
    const entries = parseChangelog(changelogPath);

    if (entries.length === 0) {
      validation.valid = false;
      validation.errors.push('Changelog is empty or could not be parsed');
      return validation;
    }

    // Normalize version (remove 'v' prefix if present)
    const normalizedVersion = expectedVersion.replace(/^v/, '');

    // Check for unreleased content
    const unreleasedEntry = entries.find(e => e.version === 'unreleased');
    if (unreleasedEntry && unreleasedEntry.content.trim().length > 0) {
      validation.hasUnreleased = true;
      validation.warnings.push(
        'Changelog has content in the Unreleased section. ' +
        'Consider moving it to the version section or removing it.'
      );
    }

    // Check for version entry
    const versionEntry = entries.find(e =>
      e.version === normalizedVersion ||
      e.version === `v${normalizedVersion}`
    );

    if (!versionEntry) {
      validation.valid = false;
      validation.hasVersionEntry = false;
      validation.errors.push(
        `Changelog does not contain an entry for version ${expectedVersion}. ` +
        `Found versions: ${entries.filter(e => e.version !== 'unreleased').map(e => e.version).join(', ')}`
      );
      return validation;
    }

    validation.hasVersionEntry = true;
    validation.versionContent = versionEntry.content;

    // Validate version entry has content
    if (!versionEntry.content || versionEntry.content.trim().length === 0) {
      validation.valid = false;
      validation.errors.push(`Changelog entry for ${expectedVersion} is empty`);
    }

    // Warn if content is very short (likely incomplete)
    if (versionEntry.content.trim().length < 20) {
      validation.warnings.push(
        `Changelog entry for ${expectedVersion} seems very short. ` +
        `Make sure to document all changes.`
      );
    }

  } catch (error: any) {
    validation.valid = false;
    validation.errors.push(`Error validating changelog: ${error.message}`);
  }

  return validation;
}

/**
 * Extract version-specific changelog content and write to a temporary file
 */
export function extractVersionChangelog(
  changelogPath: string,
  version: string,
  outputPath: string
): void {
  try {
    const entries = parseChangelog(changelogPath);
    const normalizedVersion = version.replace(/^v/, '');

    const versionEntry = entries.find(e =>
      e.version === normalizedVersion ||
      e.version === `v${normalizedVersion}`
    );

    if (!versionEntry) {
      throw new Error(`No changelog entry found for version ${version}`);
    }

    // Write the version content to the output file
    const content = `## ${version}${versionEntry.date ? ` (${versionEntry.date})` : ''}\n\n${versionEntry.content}\n`;
    Fs.writeFileSync(outputPath, content, 'utf-8');

    core.info(`Created version-specific changelog at: ${outputPath}`);
  } catch (error: any) {
    throw new Error(`Failed to extract version changelog: ${error.message}`);
  }
}

