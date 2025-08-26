# Docker Tools

DockerとKubernetes関連のスクリプト

## ファイル説明

### Docker関連
- `docker-machine start.bat` - Docker Machineの起動
- `docker-machine start - hv.bat` - Hyper-V用Docker Machine起動
- `docker_clean.bat` - Dockerコンテナとイメージのクリーンアップ

### Kubernetes関連
- `minikube start.bat` - Minikubeの起動
- `minikube start - hv.bat` - Hyper-V用Minikube起動

## 使用方法

### Docker
1. `docker-machine start.bat`でDocker Machineを起動
2. `docker_clean.bat`で不要なコンテナ・イメージを削除

### Kubernetes
1. `minikube start.bat`でMinikubeクラスターを起動
2. 必要に応じてHyper-V版を使用

