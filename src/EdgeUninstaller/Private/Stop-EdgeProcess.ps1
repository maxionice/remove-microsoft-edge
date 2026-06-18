function Stop-EdgeProcess {
    <#
    .SYNOPSIS
        Terminates all running Microsoft Edge related processes.

    .DESCRIPTION
        The installer refuses to remove Edge while any of its processes are
        active. This helper stops the browser, the WebView2 runtime hosts and
        the Edge updater so the uninstall can proceed cleanly.

    .EXAMPLE
        Stop-EdgeProcess
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $processNames = @(
        'msedge'
        'msedgewebview2'
        'MicrosoftEdgeUpdate'
        'identity_helper'
    )

    foreach ($name in $processNames) {
        $running = Get-Process -Name $name -ErrorAction SilentlyContinue
        if (-not $running) { continue }

        if ($PSCmdlet.ShouldProcess($name, 'Stop process')) {
            $running | Stop-Process -Force -ErrorAction SilentlyContinue
            Write-Verbose "Stopped process: $name"
        }
    }
}
