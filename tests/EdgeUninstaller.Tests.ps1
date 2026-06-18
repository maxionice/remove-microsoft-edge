<#
    Pester smoke tests for the EdgeUninstaller module.

    These tests validate the module's structure and metadata without actually
    uninstalling anything, so they are safe to run in CI.
#>

BeforeAll {
    $manifestPath = Join-Path $PSScriptRoot '..\src\EdgeUninstaller\EdgeUninstaller.psd1'
    Import-Module $manifestPath -Force
}

Describe 'EdgeUninstaller module' {

    It 'has a valid module manifest' {
        $manifestPath = Join-Path $PSScriptRoot '..\src\EdgeUninstaller\EdgeUninstaller.psd1'
        { Test-ModuleManifest -Path $manifestPath } | Should -Not -Throw
    }

    It 'exports the public functions' {
        $exported = (Get-Command -Module EdgeUninstaller).Name
        $exported | Should -Contain 'Uninstall-MicrosoftEdge'
        $exported | Should -Contain 'Block-EdgeReinstall'
    }

    It 'does not export private helpers' {
        $exported = (Get-Command -Module EdgeUninstaller).Name
        $exported | Should -Not -Contain 'Find-EdgeInstaller'
        $exported | Should -Not -Contain 'Write-EdgeLog'
    }
}

Describe 'Uninstall-MicrosoftEdge' {

    It 'supports -WhatIf (ShouldProcess)' {
        (Get-Command Uninstall-MicrosoftEdge).Parameters.Keys |
            Should -Contain 'WhatIf'
    }

    It 'has comment-based help' {
        (Get-Help Uninstall-MicrosoftEdge).Synopsis | Should -Not -BeNullOrEmpty
    }
}
