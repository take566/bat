docker-machine rm default -y


docker-machine create --driver hyperv default
docker-machine start default
docker-machine env default
eval "$(docker-machine env default)"
docker-machine ip default
#docker images | awk '/<none/{print $3}' | xargs docker rmi