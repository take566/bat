#cd /d C:\work\kubernetes
minikube stop
minikube delete
minikube --vm-driver=hyperv --driver=docker --extra-config=apiserver.Authorization.Mode=RBAC start  --cpus 4 --memory 8192 
minikube addons enable ingress

minikube ip