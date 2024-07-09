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
SET LOG=C:\work\log\docker_clean_%filename%.txt
docker system prune -y >> %LOG%
docker-machine rm default -y >> %LOG%
docker rmi $(docker images -a -q) >> %LOG%
