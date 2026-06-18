# Frequently Asked Questions

## Why can't I just uninstall Edge from "Apps & features"?

For most Windows installations Microsoft greys out the *Uninstall* button for
Edge because it is treated as a system component. This tool calls the official
`setup.exe` with the supported `--uninstall` switch instead.

## Is this safe?

The tool uses Microsoft's own installer — it does not patch system files or use
destructive hacks. That said, Edge is a Windows component and removing it is at
your own risk. Read [the disclaimer](../README.md#-disclaimer).

## Will Edge come back after a Windows update?

It can. Run with `-BlockReinstall` (or call `Block-EdgeReinstall`) to apply the
EdgeUpdate policy that tells Windows not to reinstall Edge automatically.

## What is WebView2 and will this break it?

Some applications embed web content using the **Edge WebView2 runtime**, which
is installed separately from the browser. This tool removes the *browser*. If an
app stops rendering content correctly afterwards, reinstall the WebView2 runtime
from Microsoft's website.

## Can I undo the reinstall block?

Yes:

```powershell
Block-EdgeReinstall -Revert
```

## Can I reinstall Edge later?

Yes. Download it again from Microsoft's official Edge website at any time.

## Does this work on Windows 10 and Windows 11?

Yes, on both, with Windows PowerShell 5.1 or PowerShell 7+.
