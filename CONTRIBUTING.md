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

We use [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer):

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
Invoke-ScriptAnalyzer -Path .\src -Recurse
```

## Tests

We use [Pester](https://pester.dev/):

```powershell
Install-Module Pester -Scope CurrentUser
Invoke-Pester .\tests
```

## Pull requests

1. Fork and create a feature branch.
2. Make your change with tests and updated docs.
3. Ensure lint and tests pass.
4. Open a pull request describing the change.
