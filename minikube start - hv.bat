#cd /d C:\work\kubernetes
minikube stop
minikube delete
minikube --vm-driver=hyperv --driver=docker start  --memory 16384
minikube addons enable ingress

minikube ip