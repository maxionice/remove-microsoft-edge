@{
    # Script module associated with this manifest.
    RootModule        = 'EdgeUninstaller.psm1'

    ModuleVersion     = '1.0.0'
    GUID              = 'b3f4c2a1-8d6e-4f2b-9c1a-7e5d3a9f0b21'

    Author            = 'Maximilian Engels'
    CompanyName       = 'Community'
    Copyright         = '(c) Maximilian Engels. MIT Licensed.'

    Description       = 'PowerShell module to cleanly uninstall Microsoft Edge (Chromium) from Windows and optionally block its automatic reinstallation.'

    PowerShellVersion = '5.1'

    # Public functions exposed to the user.
    FunctionsToExport = @(
        'Uninstall-MicrosoftEdge'
        'Block-EdgeReinstall'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags         = @(
                'Edge', 'MicrosoftEdge', 'Uninstall', 'Windows',
                'Remove', 'Debloat', 'PowerShell'
            )
            LicenseUri   = 'https://opensource.org/licenses/MIT'
            ReleaseNotes = 'Initial release: modular uninstall and reinstall-block functions.'
        }
    }
}
