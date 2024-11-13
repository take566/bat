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
 
SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%

SET LOG=C:\work\log\clist_%filename%.txt

choco upgrade all -y >> %LOG%

choco list -localonly >> %LOG%