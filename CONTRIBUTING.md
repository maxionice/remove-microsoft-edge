# Contributing

Thanks for your interest in improving **Edge Uninstaller**!

## Project layout

- One function per file under `src/EdgeUninstaller/Public` (exported) or
  `Private` (internal helpers).
- Every function uses comment-based help and `[CmdletBinding()]`.
- State-changing functions support `-WhatIf` / `-Confirm` via `ShouldProcess`.

## Development setup

```powershell
# Import the module from source while developing:
Import-Module .\src\EdgeUninstaller\EdgeUninstaller.psd1 -Force
```

## Coding style

- Comments and documentation in **English**.
- Follow standard PowerShell verb-noun naming (`Get-Verb` lists approved verbs).
- Keep functions small and single-purpose.

## Linting

We use [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) with the
shared rule set in [`PSScriptAnalyzerSettings.psd1`](PSScriptAnalyzerSettings.psd1).
Lint the **whole repository** exactly as CI does:

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
$issues = Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\PSScriptAnalyzerSettings.psd1
$issues
if ($issues) { throw "PSScriptAnalyzer found $($issues.Count) issue(s)." }
```

CI **fails** on any reported finding, so a clean run is required before merge.

## Tests

We use [Pester](https://pester.dev/) v5. Pin the same version CI uses so results
are reproducible:

```powershell
Install-Module Pester -RequiredVersion 5.6.1 -Scope CurrentUser
Invoke-Pester .\tests -Output Detailed
```

Behavioural tests mock every side effect (`Start-Process`, the private helpers,
etc.) via `InModuleScope`, so running the suite never uninstalls anything.

## Pull requests

1. Fork and create a feature branch.
2. Make your change with tests and updated docs.
3. Run lint and tests locally — both must pass.
4. Add a `## [Unreleased]` entry to [CHANGELOG.md](CHANGELOG.md).
5. Open a pull request describing the change.
