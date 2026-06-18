function Block-EdgeReinstall {
    <#
    .SYNOPSIS
        Prevents Microsoft Edge from being automatically reinstalled.

    .DESCRIPTION
        After Edge is removed, Windows update or the Edge updater may bring it
        back. This function sets the documented EdgeUpdate policy values that
        tell the updater not to install Edge (Chromium) again.

        Must be run from an elevated (administrator) PowerShell session.
        Use Block-EdgeReinstall -Revert to undo the change.

    .PARAMETER Revert
        Remove the previously written policy values to allow reinstall again.

    .EXAMPLE
        Block-EdgeReinstall

    .EXAMPLE
        Block-EdgeReinstall -Revert
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch] $Revert
    )

    if (-not (Assert-Administrator)) {
        Write-EdgeLog 'Administrator privileges are required.' -Level Error
        throw 'Please run this command from an elevated PowerShell session.'
    }

    $policyKey = 'HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate'

    # These value names instruct the Edge updater to skip (re)installation.
    $policyValues = @{
        'DoNotUpdateToEdgeWithChromium' = 1
        'InstallDefault'                = 0
        'Install{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' = 0  # Edge stable GUID
    }

    if ($Revert) {
        if (Test-Path -LiteralPath $policyKey) {
            foreach ($name in $policyValues.Keys) {
                if ($PSCmdlet.ShouldProcess("$policyKey\$name", 'Remove policy value')) {
                    Remove-ItemProperty -LiteralPath $policyKey -Name $name -ErrorAction SilentlyContinue
                }
            }
        }
        Write-EdgeLog 'Reinstall block reverted.' -Level Success
        return
    }

    # Ensure the policy key exists before writing values to it.
    if (-not (Test-Path -LiteralPath $policyKey)) {
        if ($PSCmdlet.ShouldProcess($policyKey, 'Create registry key')) {
            New-Item -Path $policyKey -Force | Out-Null
        }
    }

    foreach ($name in $policyValues.Keys) {
        if ($PSCmdlet.ShouldProcess("$policyKey\$name", 'Set policy value')) {
            New-ItemProperty -LiteralPath $policyKey -Name $name `
                -Value $policyValues[$name] -PropertyType DWord -Force | Out-Null
        }
    }

    Write-EdgeLog 'Automatic Edge reinstallation is now blocked.' -Level Success
}
