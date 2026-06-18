@echo off
REM ===========================================================================
REM  Edge Uninstaller - double-click launcher
REM  Runs the PowerShell entry point with an execution-policy bypass.
REM  The script self-elevates to administrator if required.
REM ===========================================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Uninstall-Edge.ps1"
