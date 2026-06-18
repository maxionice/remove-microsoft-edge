# Edge Uninstaller — Uninstall Microsoft Edge on Windows

> A clean, modular **PowerShell tool to uninstall Microsoft Edge (Chromium)** on
> Windows 10 and Windows 11 — and optionally **stop Windows from reinstalling it**.

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://learn.microsoft.com/powershell/)
[![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D6.svg)](#requirements)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Microsoft Edge cannot normally be removed from **Apps & features** — the
*Uninstall* button is greyed out. **Edge Uninstaller** drives the official
per-version `setup.exe` with the supported `--uninstall` switches to remove the
browser properly, then cleans up the leftovers.

---

## ✨ Features

- 🗑️ **Uninstall Microsoft Edge** using the official installer (no hacks that
  corrupt your system).
- 🧹 **Residue cleanup** — removes leftover program folders, user data and
  desktop shortcuts.
- 🔒 **Block automatic reinstall** — optional registry policy so Windows update
  doesn't bring Edge back.
- 🧩 **Modular code** — a proper PowerShell module (`EdgeUninstaller`) with one
  function per file, fully documented and testable.
- ⚡ **One-click** — a `.bat` launcher that self-elevates to administrator.

## 🚀 Quick start

**Option A — double-click**

1. Download or clone this repository.
2. Right-click [`Uninstall-Edge.bat`](Uninstall-Edge.bat) → **Run as administrator**.

**Option B — PowerShell**

```powershell
# From the repository root, in an elevated PowerShell session:
.\Uninstall-Edge.ps1

# Also prevent Windows from reinstalling Edge:
.\Uninstall-Edge.ps1 -BlockReinstall
```

**Option C — import the module (for scripting)**

```powershell
Import-Module .\src\EdgeUninstaller\EdgeUninstaller.psd1
Uninstall-MicrosoftEdge -Force
Block-EdgeReinstall            # optional
```

## 📋 Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or PowerShell 7+
- Administrator privileges (the scripts self-elevate)

## 📚 Documentation

| Document | Description |
| --- | --- |
| [docs/INSTALLATION.md](docs/INSTALLATION.md) | How to download and set up the tool |
| [docs/USAGE.md](docs/USAGE.md) | Every command, parameter and example |
| [docs/FAQ.md](docs/FAQ.md) | Common questions about removing Edge |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Fixing common problems |

## 🗂️ Project structure

```
.
├── Uninstall-Edge.ps1            # Entry point (self-elevates, runs uninstall)
├── Uninstall-Edge.bat            # Double-click launcher
├── src/EdgeUninstaller/          # The PowerShell module
│   ├── EdgeUninstaller.psd1      #   Module manifest
│   ├── EdgeUninstaller.psm1      #   Module loader (dot-sources every function)
│   ├── Public/                   #   Exported functions (one per file)
│   │   ├── Uninstall-MicrosoftEdge.ps1
│   │   └── Block-EdgeReinstall.ps1
│   └── Private/                  #   Internal helpers (one per file)
│       ├── Find-EdgeInstaller.ps1
│       ├── Stop-EdgeProcess.ps1
│       ├── Remove-EdgeResidue.ps1
│       ├── Assert-Administrator.ps1
│       └── Write-EdgeLog.ps1
├── docs/                         # Documentation (installation, usage, FAQ, …)
├── tests/                        # Pester v5 tests
├── .github/workflows/ci.yml      # CI: PSScriptAnalyzer lint + Pester tests
├── PSScriptAnalyzerSettings.psd1 # Shared lint rule set
├── CHANGELOG.md                  # Keep a Changelog history
├── CONTRIBUTING.md               # Contributor guide
└── LICENSE                       # MIT
```

## ⚠️ Disclaimer

Microsoft Edge is a component of Windows. Removing it is **at your own risk**
and may affect features that depend on the Edge WebView2 runtime. A major
Windows update can reinstall Edge. This project is not affiliated with or
endorsed by Microsoft.

## 🤝 Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## 📄 License

Released under the [MIT License](LICENSE).

---

<sub>Keywords: uninstall Microsoft Edge, remove Edge Windows 11, remove Edge
Windows 10, disable Edge, delete Microsoft Edge, Edge uninstaller PowerShell,
debloat Windows, block Edge reinstall.</sub>
