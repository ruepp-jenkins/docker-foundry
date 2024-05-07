#!/bin/bash
set -e
set -x
echo "Start build process"

# avoid some dialogs
export DEBIAN_FRONTEND=noninteractive

find /build -type f -iname "*.sh" -exec chmod +x {} \;

# preparations
/build/apt-get.sh
/build/tzdata.sh

# determinate build platform
#. /build/platforms/${TARGETPLATFORM}.sh

# add persisting
mkdir -p /docker
mv /build/files/* /docker/

# cleanup
/build/cleanup.sh
