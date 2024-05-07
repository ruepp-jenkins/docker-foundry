#!/bin/bash
set -e
echo "Cleanup docker"

docker image prune -a -f
