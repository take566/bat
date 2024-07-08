echo %date%
echo %time%

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%
SET LOG=C:\work\log\teams_%filename%.txt

dir %appdata%\Microsoft\Teams >> %LOG%
del /f %appdata%\Microsoft\Teams >> %LOG%
dir %appdata%\Microsoft\Teams >> %LOG%

dir /f %userprofile%\appdata\local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams >> %LOG%
del /f %userprofile%\appdata\local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams >> %LOG%
dir /f %userprofile%\appdata\local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams >> %LOG%