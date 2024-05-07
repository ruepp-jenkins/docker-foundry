#!/bin/bash
set -e
echo "Starting build workflow"
scripts/docker_initialize.sh
. scripts/steam.sh

# run build
echo "Building image:  ${IMAGE_FULLNAME}"
docker build \
    -t ${IMAGE_FULLNAME}:latest \
    .

docker push ${IMAGE_FULLNAME}:latest

# cleanup
scripts/docker_cleanup.sh
