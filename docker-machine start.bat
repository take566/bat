@ECHO OFF

echo %date%
echo %time%
 
set yyyy=%date:~0,4%
set mm=%date:~5,2%
set dd=%date:~8,2%
 
set time2=%time: =0%
 
set hh=%time2:~0,2%
set mn=%time2:~3,2%
set ss=%time2:~6,2%
 
set filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%
SET LOG=C:\work\log\docker_%filename%.txt


docker-machine rm default -y >> %LOG%

docker-machine stop　>> %LOG%
docker-machine create --virtualbox-no-vtx-check -d virtualbox default >> %LOG%
docker-machine start default >> %LOG%
docker-machine env default >> %LOG%
eval "$(docker-machine env default)"  >> %LOG%
docker-machine ip default >> %LOG%
#docker images | awk '/<none/{print $3}' | xargs docker rmi >> %LOG%