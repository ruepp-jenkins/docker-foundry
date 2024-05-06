#!/bin/bash
set -e
echo "Install packages"
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    lib32gcc-s1 \
    software-properties-common \
    tzdata \
    wine \
    winbind \
    xvfb \
    xserver-xorg

echo "Adding apt repositories"
add-apt-repository -y -n multiverse
dpkg --add-architecture i386

echo "Install additional packages"
apt-get update
apt-get install -y steamcmd