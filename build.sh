#!/bin/bash
sudo rm /work/docker/spoon/data-integration/logs/*.log
docker build -t cmolaro/spoon:v1.2 .
docker image ls
cat ~/docker_password.txt | docker login --username cmolaro --password-stdin
docker push cmolaro/spoon:v1.2 
docker run --rm cmolaro/spoon:v1.2
docker run --rm -v $(pwd):/jobs cmolaro/spoon:v1.2 runt sample/dummy.ktr
