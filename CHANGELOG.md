# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Fixed
- `Uninstall-MicrosoftEdge` now returns `$false` (instead of always `$true`)
  when `setup.exe` exits with a non-zero code, so callers can detect failure.
- `-WhatIf` is now always honoured even together with `-Force`; a preview can
  no longer trigger the real uninstall.
- Residue cleanup now removes per-user Edge data and desktop shortcuts for
  **every** user profile, not just the elevated session's profile.

### Changed
- CI now **fails** on PSScriptAnalyzer findings (the previous step never did)
  and lints the whole repository via `PSScriptAnalyzerSettings.psd1`.
- Pester is pinned to a fixed version in CI for reproducible runs.

### Added
- Behavioural Pester tests (with mocks) for `Find-EdgeInstaller` version
  selection and `Uninstall-MicrosoftEdge` exit-code / cleanup logic.
- `ProjectUri` in the module manifest for PowerShell Gallery metadata.

## [1.0.0] - 2026-06-18

### Added
- `Uninstall-MicrosoftEdge` — uninstalls Edge via the official installer.
- `Block-EdgeReinstall` — blocks (and reverts) automatic Edge reinstallation.
- `Uninstall-Edge.ps1` self-elevating entry-point script.
- `Uninstall-Edge.bat` double-click launcher.
- Full documentation set under `docs/`.
- Pester smoke tests and a PSScriptAnalyzer CI workflow.
