@echo off
set YYYY=%date:~0,4%
set MM=%date:~5,2%
set DD=%date:~8,2%
set BACKUP_DATE=%YYYY%%MM%%DD%
set BACKUP_DIR=Z:\bk\%BACKUP_DATE%
set LOG_FILE=Z:\bk\log\backup_%BACKUP_DATE%.log

if not exist "Z:\bk\logs" mkdir "Z:\bk\logs"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

robocopy "D:\work" "%BACKUP_DIR%" /S /COPY:DAT /LOG:"%LOG_FILE%"