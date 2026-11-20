@echo off
title TurfBook Auto-Sync Service
echo ========================================================
echo        TurfBook Real-Time Auto-Sync to Desktop
echo ========================================================
echo.
for %%I in ("%~dp0..") do set "ROOT_DIR=%%~fI"
echo Source:      %ROOT_DIR%
echo Destination: C:\Users\sridh\OneDrive\Desktop\New folder\TurfBook
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-to-desktop.ps1"
pause
