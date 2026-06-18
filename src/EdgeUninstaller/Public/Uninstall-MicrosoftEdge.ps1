function Uninstall-MicrosoftEdge {
    <#
    .SYNOPSIS
        Uninstalls Microsoft Edge (Chromium) from the local machine.

    .DESCRIPTION
        Microsoft Edge cannot normally be removed through "Apps & features".
        This function drives the official per-version setup.exe with the
        documented --uninstall switches, terminates Edge processes first and
        optionally cleans up any residual files afterwards.

        Must be run from an elevated (administrator) PowerShell session.

    .PARAMETER SkipResidueCleanup
        Leave residual Edge folders and shortcuts in place after the uninstall.

    .PARAMETER Force
        Suppress the confirmation prompt and proceed immediately.

    .EXAMPLE
        Uninstall-MicrosoftEdge

    .EXAMPLE
        Uninstall-MicrosoftEdge -Force -SkipResidueCleanup

    .OUTPUTS
        System.Boolean. $true when an installer was found and invoked.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([bool])]
    param(
        [switch] $SkipResidueCleanup,
        [switch] $Force
    )

    Write-EdgeLog 'Microsoft Edge uninstaller starting...' -Level Info

    # 1. Elevation is mandatory; bail out early with a clear message.
    if (-not (Assert-Administrator)) {
        Write-EdgeLog 'Administrator privileges are required.' -Level Error
        throw 'Please run this command from an elevated PowerShell session.'
    }

    # 2. Honour -Force by short-circuiting the ShouldProcess prompt.
    if (-not ($Force -or $PSCmdlet.ShouldProcess('Microsoft Edge', 'Uninstall'))) {
        Write-EdgeLog 'Uninstall cancelled by user.' -Level Warning
        return $false
    }

    # 3. Locate the maintenance installer.
    $setup = Find-EdgeInstaller
    if (-not $setup) {
        Write-EdgeLog 'No Edge installer found. Edge may already be removed.' -Level Warning
        if (-not $SkipResidueCleanup) { Remove-EdgeResidue }
        return $false
    }

    # 4. Edge must not be running during the uninstall.
    Write-EdgeLog 'Stopping running Edge processes...' -Level Info
    Stop-EdgeProcess

    # 5. Invoke the documented uninstall switches and wait for completion.
    Write-EdgeLog "Running installer: $setup" -Level Info
    $arguments = @(
        '--uninstall'
        '--system-level'
        '--verbose-logging'
        '--force-uninstall'
    )
    $process = Start-Process -FilePath $setup -ArgumentList $arguments -Wait -PassThru
    Write-EdgeLog "Installer exited with code $($process.ExitCode)." -Level Info

    # 6. Optional cleanup of residual files and shortcuts.
    if (-not $SkipResidueCleanup) {
        Write-EdgeLog 'Cleaning up residual files...' -Level Info
        Remove-EdgeResidue
    }

    Write-EdgeLog 'Done. Microsoft Edge has been removed where possible.' -Level Success
    Write-EdgeLog 'Note: Windows updates may reinstall Edge later.' -Level Warning
    return $true
}
