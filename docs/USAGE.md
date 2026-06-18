# Usage

All commands require an **elevated** (administrator) session. The provided
scripts self-elevate automatically.

## The entry-point script

`Uninstall-Edge.ps1` is the simplest way to run the tool.

```powershell
# Uninstall Edge and clean up leftovers:
.\Uninstall-Edge.ps1

# Uninstall Edge and block Windows from reinstalling it:
.\Uninstall-Edge.ps1 -BlockReinstall

# Uninstall Edge but keep residual files/shortcuts:
.\Uninstall-Edge.ps1 -SkipResidueCleanup
```

| Parameter | Description |
| --- | --- |
| `-BlockReinstall` | Apply the policy that prevents automatic reinstallation. |
| `-SkipResidueCleanup` | Do not delete leftover folders and shortcuts. |

## The module functions

Import the module for full control or for use in your own scripts:

```powershell
Import-Module .\src\EdgeUninstaller\EdgeUninstaller.psd1
```

### `Uninstall-MicrosoftEdge`

Uninstalls Edge using the official installer.

```powershell
Uninstall-MicrosoftEdge                 # prompts for confirmation
Uninstall-MicrosoftEdge -Force          # no prompt
Uninstall-MicrosoftEdge -WhatIf         # show what would happen
Uninstall-MicrosoftEdge -SkipResidueCleanup
```

| Parameter | Description |
| --- | --- |
| `-Force` | Skip the confirmation prompt. |
| `-SkipResidueCleanup` | Keep residual files and shortcuts. |
| `-WhatIf` / `-Confirm` | Standard PowerShell safety switches. |

### `Block-EdgeReinstall`

Sets (or reverts) the EdgeUpdate policy that blocks reinstallation.

```powershell
Block-EdgeReinstall            # block reinstall
Block-EdgeReinstall -Revert    # allow reinstall again
```

| Parameter | Description |
| --- | --- |
| `-Revert` | Remove the policy values, allowing reinstall. |

## Getting help

Every function ships with comment-based help:

```powershell
Get-Help Uninstall-MicrosoftEdge -Full
Get-Help Block-EdgeReinstall -Examples
```
