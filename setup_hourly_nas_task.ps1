# PowerShell script to create hourly NAS mount task
# Run this script as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges. Please run as Administrator."
    exit 1
}

Write-Host "Setting up hourly NAS mount task..." -ForegroundColor Green

# Remove existing task if it exists
$taskName = "NAS Mount Task"
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Create action
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"cd /d D:\work\bat && nas_mount.bat`"" -WorkingDirectory "D:\work\bat"

# Create trigger for logon
$logonTrigger = New-ScheduledTaskTrigger -AtLogOn

# Create trigger for daily at 9 AM
$dailyTrigger = New-ScheduledTaskTrigger -Daily -At 9AM

# Create trigger for every hour
$hourlyTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration (New-TimeSpan -Days 365)

# Create principal
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 1)

# Register the task
try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $logonTrigger, $dailyTrigger, $hourlyTrigger -Principal $principal -Settings $settings -Description "NASドライブを1時間おきにチェックし、マウントされていない場合にマウントするタスク"
    Write-Host "Task created successfully!" -ForegroundColor Green
    Write-Host "Task name: $taskName" -ForegroundColor Cyan
    Write-Host "Schedule:" -ForegroundColor Cyan
    Write-Host " - System logon" -ForegroundColor White
    Write-Host " - Daily at 9:00 AM" -ForegroundColor White
    Write-Host " - Every hour (only if not mounted)" -ForegroundColor White
    
    # Show task details
    Write-Host "`nTask details:" -ForegroundColor Yellow
    Get-ScheduledTask -TaskName $taskName | Get-ScheduledTaskInfo | Format-List
} catch {
    Write-Host "Error creating task: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 