#!/bin/bash
set -e
set -x
echo "Starting build workflow"
scripts/docker_initialize.sh
. scripts/steam.sh

# run build
echo "Building image:  ${IMAGE_FULLNAME}"
docker buildx build \
    --build-arg STEAM_GAMESERVERID="${STEAM_GAMESERVERID}" \
    --build-arg GAMESERVER_CMD="${GAMESERVER_CMD}" \
    --platform linux/amd64 \
    -t ${IMAGE_FULLNAME}:latest \
    --push .

# cleanup
scripts/docker_cleanup.sh
