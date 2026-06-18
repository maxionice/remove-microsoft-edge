function Write-EdgeLog {
    <#
    .SYNOPSIS
        Writes a colour-coded, timestamped log message to the host.

    .DESCRIPTION
        Centralised logging helper used by every function in the module so
        that output is consistent and easy to parse. Supports four severity
        levels, each mapped to a distinct console colour.

    .PARAMETER Message
        The text to write.

    .PARAMETER Level
        Severity of the message. One of Info, Success, Warning or Error.

    .EXAMPLE
        Write-EdgeLog -Message 'Edge removed.' -Level Success
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter(Position = 1)]
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string] $Level = 'Info'
    )

    # Map each severity level to a console colour.
    $colour = switch ($Level) {
        'Success' { 'Green' }
        'Warning' { 'Yellow' }
        'Error'   { 'Red' }
        default   { 'Cyan' }
    }

    $timestamp = (Get-Date).ToString('HH:mm:ss')
    Write-Host "[$timestamp] " -NoNewline -ForegroundColor DarkGray
    Write-Host $Message -ForegroundColor $colour
}
