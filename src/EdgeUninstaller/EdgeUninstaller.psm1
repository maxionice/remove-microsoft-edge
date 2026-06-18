<#
    EdgeUninstaller root module.

    Dot-sources every function from the Public and Private folders and then
    exports only the public functions. This "one function per file" layout
    keeps the module modular and easy to test and extend.
#>

$ErrorActionPreference = 'Stop'

# Discover function files in both folders.
$public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)
$private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)

# Load every function into the module scope.
foreach ($file in @($public + $private)) {
    try {
        . $file.FullName
    }
    catch {
        Write-Error "Failed to import function '$($file.FullName)': $_"
    }
}

# Only public functions form the module's surface area.
Export-ModuleMember -Function $public.BaseName
