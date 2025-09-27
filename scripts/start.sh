#!/bin/bash
set -e
echo "Starting build workflow"
scripts/docker_initialize.sh

DATESTAMP=$(date +%Y%m%d)

# run build
echo "Building image:  ${IMAGE_FULLNAME}"
docker build \
    -t ${IMAGE_FULLNAME}:latest \
    -t ${IMAGE_FULLNAME}:${DATESTAMP} \
    --pull \
    --push .
