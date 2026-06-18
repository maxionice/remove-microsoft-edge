function Assert-Administrator {
    <#
    .SYNOPSIS
        Determines whether the current session is running elevated.

    .DESCRIPTION
        Returns $true when the current Windows identity is a member of the
        local Administrators role, otherwise $false. Removing Microsoft Edge
        requires administrative privileges, so callers use this to fail fast
        or to self-elevate.

    .OUTPUTS
        System.Boolean

    .EXAMPLE
        if (-not (Assert-Administrator)) { throw 'Run as administrator.' }
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}
