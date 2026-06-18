# Installation

This guide explains how to get **Edge Uninstaller** onto your machine.

## Option 1 — Download the ZIP

1. On the GitHub repository page, click **Code → Download ZIP**.
2. Extract the ZIP to a folder of your choice, e.g. `C:\Tools\edge-uninstaller`.
3. Continue with [USAGE.md](USAGE.md).

## Option 2 — Clone with Git

```powershell
git clone https://github.com/<your-user>/edge-uninstaller.git
cd edge-uninstaller
```

## Execution policy

The provided `.bat` launcher and the entry-point script already pass
`-ExecutionPolicy Bypass`, so you do **not** need to change your system
execution policy. If you import the module manually and hit a policy error,
run this in an **elevated** session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

This relaxes the policy only for the current session.

## Verifying the download

The module is plain text — you can read every script before running it. Start
with [`src/EdgeUninstaller/Public`](../src/EdgeUninstaller/Public) to see exactly
what the tool does.
