function Remove-EdgeResidue {
    <#
    .SYNOPSIS
        Removes files and shortcuts left behind after uninstalling Edge.

    .DESCRIPTION
        Even after a successful uninstall, Edge can leave program folders,
        per-user data and desktop shortcuts on disk. This function deletes
        those residual items. It honours -WhatIf / -Confirm via ShouldProcess.

    .EXAMPLE
        Remove-EdgeResidue -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    # Leftover machine-wide program directories.
    $folders = [System.Collections.Generic.List[string]]::new()
    $folders.Add((Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge'))
    $folders.Add((Join-Path $env:ProgramFiles        'Microsoft\Edge'))

    # Per-user data lives under each profile's LocalAppData. The script runs
    # elevated, so $env:LOCALAPPDATA is often the admin profile rather than the
    # signed-in user's. Enumerate every profile so no user's data is missed.
    $usersRoot = Join-Path $env:SystemDrive 'Users'
    if (Test-Path -LiteralPath $usersRoot) {
        foreach ($userProfile in Get-ChildItem -LiteralPath $usersRoot -Directory -ErrorAction SilentlyContinue) {
            $folders.Add((Join-Path $userProfile.FullName 'AppData\Local\Microsoft\Edge'))
        }
    }

    foreach ($folder in $folders) {
        if (-not (Test-Path -LiteralPath $folder)) { continue }

        if ($PSCmdlet.ShouldProcess($folder, 'Remove folder')) {
            Remove-Item -LiteralPath $folder -Recurse -Force -ErrorAction SilentlyContinue
            Write-Verbose "Removed folder: $folder"
        }
    }

    # Desktop shortcuts (public desktop plus each user's own desktop).
    $shortcuts = [System.Collections.Generic.List[string]]::new()
    $shortcuts.Add((Join-Path $env:PUBLIC 'Desktop\Microsoft Edge.lnk'))
    if (Test-Path -LiteralPath $usersRoot) {
        foreach ($userProfile in Get-ChildItem -LiteralPath $usersRoot -Directory -ErrorAction SilentlyContinue) {
            $shortcuts.Add((Join-Path $userProfile.FullName 'Desktop\Microsoft Edge.lnk'))
        }
    }

    foreach ($shortcut in $shortcuts) {
        if (-not (Test-Path -LiteralPath $shortcut)) { continue }

        if ($PSCmdlet.ShouldProcess($shortcut, 'Remove shortcut')) {
            Remove-Item -LiteralPath $shortcut -Force -ErrorAction SilentlyContinue
            Write-Verbose "Removed shortcut: $shortcut"
        }
    }
}
