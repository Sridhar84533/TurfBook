# Real-time Auto-Sync Script for TurfBook
# Syncs changes from Documents\TurfBook -> Desktop\New folder\TurfBook

$Source = "C:\Users\sridh\OneDrive\Documents\TurfBook"
$Destination = "C:\Users\sridh\OneDrive\Desktop\New folder\TurfBook"

if (-not (Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

function Sync-Files {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Syncing changes to Desktop\New folder\TurfBook..." -ForegroundColor Cyan
    # Robocopy /MIR ensures added, modified, and deleted files are matched exactly
    # Exclude common temp / lock / git files if present
    robocopy "$Source" "$Destination" /MIR /FFT /Z /R:2 /W:1 /XD ".git" ".vscode" /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Sync complete." -ForegroundColor Green
}

# Initial sync
Sync-Files

# Setup FileSystemWatcher
$Watcher = New-Object System.IO.FileSystemWatcher
$Watcher.Path = $Source
$Watcher.IncludeSubdirectories = $true
$Watcher.EnableRaisingEvents = $true
$Watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite, DirectoryName, Size'

Write-Host "Auto-sync watcher is actively running." -ForegroundColor Green
Write-Host "Watching: $Source"
Write-Host "Target:   $Destination"
Write-Host "Press Ctrl+C to stop."

try {
    while ($true) {
        $change = $Watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All, 1000)
        if (-not $change.TimedOut) {
            # Drain any burst of edits over 1.5 seconds before syncing
            Start-Sleep -Milliseconds 1500
            Sync-Files
        }
    }
}
finally {
    $Watcher.EnableRaisingEvents = $false
    $Watcher.Dispose()
    Write-Host "Watcher stopped." -ForegroundColor Yellow
}
