@echo off
echo Stopping TurfBook Auto-Sync processes...
powershell -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*sync-to-desktop.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force; Write-Host 'Stopped auto-sync process ID:' $_.ProcessId }"
echo Done.
timeout /t 3
