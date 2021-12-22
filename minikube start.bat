#cd /d D:
minikube stop
minikube delete
minikube --vm-driver=virtualbox --driver=docker start  --memory 4096