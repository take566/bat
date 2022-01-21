#cd /d D:
minikube stop
minikube delete
minikube --vm-driver=virtualbox --driver=docker start  --cpus 4 --memory 8192 