function Find-EdgeInstaller {
    <#
    .SYNOPSIS
        Locates the Microsoft Edge maintenance installer (setup.exe).

    .DESCRIPTION
        Microsoft Edge ships a per-version "setup.exe" inside its application
        directory. That binary is the only supported way to uninstall the
        browser, so this function searches the well-known installation roots
        and returns the path to the newest version's installer.

    .OUTPUTS
        System.String. The full path to setup.exe, or $null when not found.

    .EXAMPLE
        $setup = Find-EdgeInstaller
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # Standard installation roots for both 64-bit and 32-bit Program Files.
    $applicationRoots = @(
        Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application'
        Join-Path $env:ProgramFiles        'Microsoft\Edge\Application'
    )

    foreach ($root in $applicationRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }

        # Version folders are named like "124.0.2478.80". Sort by the parsed
        # version so we always target the newest installer present.
        $versionFolders =
            Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '^\d+(\.\d+)+$' } |
            Sort-Object { [version] $_.Name } -Descending

        foreach ($folder in $versionFolders) {
            $setup = Join-Path $folder.FullName 'Installer\setup.exe'
            if (Test-Path -LiteralPath $setup) {
                Write-Verbose "Found Edge installer: $setup"
                return $setup
            }
        }
    }

    return $null
}
