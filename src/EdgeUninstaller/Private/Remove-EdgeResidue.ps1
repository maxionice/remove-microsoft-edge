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

    # Leftover program and user-data directories.
    $folders = @(
        Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge'
        Join-Path $env:ProgramFiles        'Microsoft\Edge'
        Join-Path $env:LOCALAPPDATA        'Microsoft\Edge'
    )

    foreach ($folder in $folders) {
        if (-not (Test-Path -LiteralPath $folder)) { continue }

        if ($PSCmdlet.ShouldProcess($folder, 'Remove folder')) {
            Remove-Item -LiteralPath $folder -Recurse -Force -ErrorAction SilentlyContinue
            Write-Verbose "Removed folder: $folder"
        }
    }

    # Public desktop shortcut.
    $shortcut = Join-Path $env:PUBLIC 'Desktop\Microsoft Edge.lnk'
    if (Test-Path -LiteralPath $shortcut) {
        if ($PSCmdlet.ShouldProcess($shortcut, 'Remove shortcut')) {
            Remove-Item -LiteralPath $shortcut -Force -ErrorAction SilentlyContinue
            Write-Verbose "Removed shortcut: $shortcut"
        }
    }
}
