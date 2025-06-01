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
SET LOG=log\minikube_%filename%.txt

cd /d kubernetes  >> %LOG%

minikube stop >> %LOG%
minikube delete >> %LOG%
minikube config set driver docker >> %LOG%
minikube start  --cpus 4 --memory 8192 --driver=docker >> %LOG%