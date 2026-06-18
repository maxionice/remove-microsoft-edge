# Troubleshooting

## "Administrator privileges are required."

Run the tool elevated. Either right-click `Uninstall-Edge.bat` → **Run as
administrator**, or open PowerShell as administrator before running the script.

## "No Edge installer found."

The tool searches these locations for `setup.exe`:

- `%ProgramFiles(x86)%\Microsoft\Edge\Application\<version>\Installer`
- `%ProgramFiles%\Microsoft\Edge\Application\<version>\Installer`

If nothing is found, Edge is probably already removed. Any leftover files are
cleaned up unless you passed `-SkipResidueCleanup`.

## The script is blocked by execution policy

Use the `.bat` launcher (it bypasses the policy), or run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Edge reinstalled itself after an update

Apply the reinstall block:

```powershell
Import-Module .\src\EdgeUninstaller\EdgeUninstaller.psd1
Block-EdgeReinstall
```

## An app no longer renders web content

That app likely depends on the **Edge WebView2 runtime**. Reinstall the WebView2
runtime from Microsoft's official download page — it is independent of the
browser this tool removes.

## The installer exits with a non-zero code

The exit code is printed to the console, and `Uninstall-MicrosoftEdge` now
reports the failure (it logs an **Error** line and returns `$false`) instead of
claiming success. A non-zero code usually means Edge was still running (close all
windows and retry) or that another installer instance was active. Reboot and run
the tool again.

When scripting, check the return value:

```powershell
if (-not (Uninstall-MicrosoftEdge -Force)) {
    Write-Warning 'Edge was not removed - see the log above.'
}
```

## Reporting a bug

Open an issue on the GitHub repository and include:

- Your Windows version (`winver`)
- Your PowerShell version (`$PSVersionTable.PSVersion`)
- The full console output
