import { test, describe } from 'node:test';
import assert from 'node:assert';
import { parseChangelog, validateChangelog, extractVersionChangelog } from './changelog';
import Fs from 'fs';
import Path from 'path';
import OS from 'os';

describe('parseChangelog', () => {
  test('parses version entries with date', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-1.md');
    const content = `# Changelog

## v1.0.0 (2025-01-13)

- Added feature A
- Fixed bug B

## v0.9.0 (2025-01-01)

- Initial release
`;
    Fs.writeFileSync(testFile, content);

    const entries = parseChangelog(testFile);

    assert.strictEqual(entries.length, 2);
    assert.strictEqual(entries[0].version, '1.0.0');
    assert.strictEqual(entries[0].date, '2025-01-13');
    assert.ok(entries[0].content.includes('Added feature A'));
    assert.strictEqual(entries[1].version, '0.9.0');

    Fs.unlinkSync(testFile);
  });

  test('parses version entries without date', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-2.md');
    const content = `## 1.0.0

- Added feature A

## 0.9.0

- Initial release
`;
    Fs.writeFileSync(testFile, content);

    const entries = parseChangelog(testFile);

    assert.strictEqual(entries.length, 2);
    assert.strictEqual(entries[0].version, '1.0.0');
    assert.strictEqual(entries[0].date, undefined);
    assert.strictEqual(entries[1].version, '0.9.0');

    Fs.unlinkSync(testFile);
  });

  test('parses unreleased section', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-3.md');
    const content = `# Changelog

## Unreleased

- Work in progress

## v1.0.0

- Released feature
`;
    Fs.writeFileSync(testFile, content);

    const entries = parseChangelog(testFile);

    assert.strictEqual(entries.length, 2);
    assert.strictEqual(entries[0].version, 'unreleased');
    assert.ok(entries[0].content.includes('Work in progress'));
    assert.strictEqual(entries[1].version, '1.0.0');

    Fs.unlinkSync(testFile);
  });

  test('parses beta/pre-release versions', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-4.md');
    const content = `## 1.0.0-beta.1

- Beta release
`;
    Fs.writeFileSync(testFile, content);

    const entries = parseChangelog(testFile);

    assert.strictEqual(entries.length, 1);
    assert.strictEqual(entries[0].version, '1.0.0-beta.1');

    Fs.unlinkSync(testFile);
  });

  test('returns empty array for empty file', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-5.md');
    Fs.writeFileSync(testFile, '');

    const entries = parseChangelog(testFile);

    assert.strictEqual(entries.length, 0);

    Fs.unlinkSync(testFile);
  });
});

describe('validateChangelog', () => {
  test('validates changelog with matching version', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-6.md');
    const content = `## 1.0.0

- Added feature A
- Fixed bug B
`;
    Fs.writeFileSync(testFile, content);

    const validation = validateChangelog(testFile, '1.0.0');

    assert.strictEqual(validation.valid, true);
    assert.strictEqual(validation.hasVersionEntry, true);
    assert.strictEqual(validation.hasUnreleased, false);
    assert.strictEqual(validation.errors.length, 0);
    assert.ok(validation.versionContent?.includes('Added feature A'));

    Fs.unlinkSync(testFile);
  });

  test('validates changelog with v prefix in version', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-7.md');
    const content = `## v1.0.0

- Added feature A
`;
    Fs.writeFileSync(testFile, content);

    const validation = validateChangelog(testFile, '1.0.0');

    assert.strictEqual(validation.valid, true);
    assert.strictEqual(validation.hasVersionEntry, true);

    Fs.unlinkSync(testFile);
  });

  test('warns about unreleased content', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-8.md');
    const content = `## Unreleased

- Work in progress

## 1.0.0

- Released feature
`;
    Fs.writeFileSync(testFile, content);

    const validation = validateChangelog(testFile, '1.0.0');

    assert.strictEqual(validation.valid, true);
    assert.strictEqual(validation.hasUnreleased, true);
    assert.ok(validation.warnings.length > 0);
    assert.ok(validation.warnings[0].includes('Unreleased'));

    Fs.unlinkSync(testFile);
  });

  test('fails when version not found', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-9.md');
    const content = `## 0.9.0

- Old version
`;
    Fs.writeFileSync(testFile, content);

    const validation = validateChangelog(testFile, '1.0.0');

    assert.strictEqual(validation.valid, false);
    assert.strictEqual(validation.hasVersionEntry, false);
    assert.ok(validation.errors.length > 0);
    assert.ok(validation.errors[0].includes('does not contain an entry'));

    Fs.unlinkSync(testFile);
  });

  test('fails when version entry is empty', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-10.md');
    const content = `## 1.0.0

## 0.9.0

- Old version
`;
    Fs.writeFileSync(testFile, content);

    const validation = validateChangelog(testFile, '1.0.0');

    assert.strictEqual(validation.valid, false);
    assert.ok(validation.errors.some(e => e.includes('is empty')));

    Fs.unlinkSync(testFile);
  });

  test('warns when version entry is too short', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-11.md');
    const content = `## 1.0.0

- Fix
`;
    Fs.writeFileSync(testFile, content);

    const validation = validateChangelog(testFile, '1.0.0');

    assert.strictEqual(validation.valid, true);
    assert.ok(validation.warnings.some(w => w.includes('seems very short')));

    Fs.unlinkSync(testFile);
  });

  test('fails when file does not exist', () => {
    const validation = validateChangelog('/nonexistent/file.md', '1.0.0');

    assert.strictEqual(validation.valid, false);
    assert.ok(validation.errors[0].includes('not found'));
  });
});

describe('extractVersionChangelog', () => {
  test('extracts version-specific changelog', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-12.md');
    const outputFile = Path.join(OS.tmpdir(), 'test-changelog-12-1.0.0.md');
    const content = `## 1.0.0 (2025-01-13)

- Added feature A
- Fixed bug B

## 0.9.0

- Old version
`;
    Fs.writeFileSync(testFile, content);

    extractVersionChangelog(testFile, '1.0.0', outputFile);

    assert.ok(Fs.existsSync(outputFile));
    const extracted = Fs.readFileSync(outputFile, 'utf-8');
    assert.ok(extracted.includes('1.0.0'));
    assert.ok(extracted.includes('Added feature A'));
    assert.ok(!extracted.includes('Old version'));

    Fs.unlinkSync(testFile);
    Fs.unlinkSync(outputFile);
  });

  test('extracts version with v prefix', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-13.md');
    const outputFile = Path.join(OS.tmpdir(), 'test-changelog-13-1.0.0.md');
    const content = `## v1.0.0

- Feature A
`;
    Fs.writeFileSync(testFile, content);

    extractVersionChangelog(testFile, 'v1.0.0', outputFile);

    assert.ok(Fs.existsSync(outputFile));
    const extracted = Fs.readFileSync(outputFile, 'utf-8');
    assert.ok(extracted.includes('Feature A'));

    Fs.unlinkSync(testFile);
    Fs.unlinkSync(outputFile);
  });

  test('throws error when version not found', () => {
    const testFile = Path.join(OS.tmpdir(), 'test-changelog-14.md');
    const outputFile = Path.join(OS.tmpdir(), 'test-changelog-14-2.0.0.md');
    const content = `## 1.0.0

- Feature A
`;
    Fs.writeFileSync(testFile, content);

    assert.throws(
      () => extractVersionChangelog(testFile, '2.0.0', outputFile),
      /No changelog entry found/
    );

    Fs.unlinkSync(testFile);
  });
});

