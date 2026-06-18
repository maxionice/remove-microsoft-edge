<#
.SYNOPSIS
    Entry point script: self-elevates and uninstalls Microsoft Edge.

.DESCRIPTION
    Convenience bootstrapper for users who just want to double-click and go.
    It re-launches itself as administrator if needed, imports the
    EdgeUninstaller module and runs the uninstall. For scripting and finer
    control, import the module directly and call Uninstall-MicrosoftEdge.

.PARAMETER BlockReinstall
    Also apply the policy that prevents Windows from reinstalling Edge.

.PARAMETER SkipResidueCleanup
    Leave residual Edge files and shortcuts on disk.

.EXAMPLE
    .\Uninstall-Edge.ps1

.EXAMPLE
    .\Uninstall-Edge.ps1 -BlockReinstall
#>
[CmdletBinding()]
param(
    [switch] $BlockReinstall,
    [switch] $SkipResidueCleanup
)

# Re-launch elevated when not already running as administrator.
$identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
$isAdmin   = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host 'Elevation required. Restarting as administrator...' -ForegroundColor Yellow

    # Build the argument list, forwarding the original switches.
    $launchArgs = @(
        '-NoProfile'
        '-ExecutionPolicy', 'Bypass'
        '-File', "`"$PSCommandPath`""
    )
    if ($BlockReinstall)     { $launchArgs += '-BlockReinstall' }
    if ($SkipResidueCleanup) { $launchArgs += '-SkipResidueCleanup' }

    Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList $launchArgs
    return
}

# Import the module from the local source tree.
$modulePath = Join-Path $PSScriptRoot 'src\EdgeUninstaller\EdgeUninstaller.psd1'
Import-Module $modulePath -Force

# Run the uninstall, forwarding caller options.
Uninstall-MicrosoftEdge -Force -SkipResidueCleanup:$SkipResidueCleanup

if ($BlockReinstall) {
    Block-EdgeReinstall
}

Read-Host 'Press Enter to exit'
