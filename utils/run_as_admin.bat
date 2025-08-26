@echo off
echo Running PowerShell script as Administrator...
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0setup_hourly_nas_task.ps1\"' -Verb RunAs"
pause 