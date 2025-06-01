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
SET LOG=log\minikube_hv_%filename%.txt

cd /d kubernetes
minikube stop >> %LOG%
minikube delete >> %LOG%
minikube --vm-driver=hyperv --driver=docker --extra-config=apiserver.Authorization.Mode=RBAC start  --cpus 4 --memory 8192 >> %LOG%
minikube addons enable ingress >> %LOG%

minikube ip >> %LOG%