#cd /d D:
minikube stop
minikube delete
minikube --vm-driver=virtualbox --driver=docker --extra-config=apiserver.Authorization.Mode=RBAC start  --cpus 4 --memory 8192 