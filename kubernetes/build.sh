#!/bin/bash
export TAG="v2.0"
sudo rm /work/docker/spoon/data-integration/logs/*.log
docker build -t cmolaro/spoon:$TAG .
docker image ls
cat ~/docker_password.txt | docker login --username cmolaro --password-stdin
docker push cmolaro/spoon:$TAG
docker run --rm cmolaro/spoon:$TAG
docker run --rm -v $(pwd):/jobs cmolaro/spoon:$TAG runt sample/dummy.ktr
