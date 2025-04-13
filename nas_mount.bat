@echo off
echo %date%
echo %time%

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET LOG_DIR=C:\work\log
REM Check if the log directory exists, create it if it doesn't
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)
SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%
SET LOG=C:\work\log\nas_mount_%filename%.txt
net use J: /DELETE /y
net use X: /DELETE /y
net use Y: /DELETE /y
net use Z: /DELETE /y

REM 資格情報を使用してネットワークドライブをマウント
net use X: \\AS4002T-A6F7\Music /user:admin /savecred
net use Y: \\AS4002T-A6F7\Media 
net use Z: \\AS4002T-A6F7\Home
net use J: \\AS4002T-A6F7\Docker
