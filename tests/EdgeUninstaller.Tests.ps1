<#
    Pester tests for the EdgeUninstaller module.

    Two layers of coverage, neither of which uninstalls anything (so they are
    safe to run anywhere, including CI):
      * Structure/metadata checks on the public surface and manifest.
      * Behavioural checks that mock every side effect via InModuleScope to
        verify installer discovery and the uninstall return-value logic.
#>

# Imported at script (discovery) scope as well so that InModuleScope below can
# resolve the module while Pester is discovering the tests it contains.
$manifestPath = Join-Path $PSScriptRoot '..\src\EdgeUninstaller\EdgeUninstaller.psd1'
Import-Module $manifestPath -Force

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

# Behavioural tests run inside the module scope so they can mock the private
# helpers. Nothing is actually uninstalled - every side effect is mocked.
InModuleScope EdgeUninstaller {

    Describe 'Find-EdgeInstaller' {

        It 'returns the newest version installer' {
            Mock Test-Path { $true }
            Mock Get-ChildItem {
                @(
                    [pscustomobject]@{ Name = '124.0.2478.80';  FullName = 'C:\Edge\124.0.2478.80' }
                    [pscustomobject]@{ Name = '99.0.100.0';     FullName = 'C:\Edge\99.0.100.0' }
                    [pscustomobject]@{ Name = '124.0.2478.105'; FullName = 'C:\Edge\124.0.2478.105' }
                )
            }

            Find-EdgeInstaller | Should -Match '124\.0\.2478\.105'
        }

        It 'returns $null when no installation root exists' {
            Mock Test-Path { $false }
            Find-EdgeInstaller | Should -BeNullOrEmpty
        }
    }

    Describe 'Uninstall-MicrosoftEdge logic' {

        BeforeEach {
            Mock Assert-Administrator { $true }
            Mock Stop-EdgeProcess { }
            Mock Remove-EdgeResidue { }
            Mock Write-EdgeLog { }
        }

        It 'returns $false and never launches the installer when none is found' {
            Mock Find-EdgeInstaller { $null }
            Mock Start-Process { }

            Uninstall-MicrosoftEdge -Force | Should -BeFalse
            Should -Invoke Start-Process -Times 0
        }

        It 'returns $false when the installer exits non-zero' {
            Mock Find-EdgeInstaller { 'C:\fake\setup.exe' }
            Mock Start-Process { [pscustomobject]@{ ExitCode = 1 } }

            Uninstall-MicrosoftEdge -Force | Should -BeFalse
        }

        It 'returns $true when the installer succeeds' {
            Mock Find-EdgeInstaller { 'C:\fake\setup.exe' }
            Mock Start-Process { [pscustomobject]@{ ExitCode = 0 } }

            Uninstall-MicrosoftEdge -Force -SkipResidueCleanup | Should -BeTrue
        }

        It 'skips residue cleanup when -SkipResidueCleanup is set' {
            Mock Find-EdgeInstaller { 'C:\fake\setup.exe' }
            Mock Start-Process { [pscustomobject]@{ ExitCode = 0 } }

            Uninstall-MicrosoftEdge -Force -SkipResidueCleanup | Out-Null
            Should -Invoke Remove-EdgeResidue -Times 0
        }
    }
}
