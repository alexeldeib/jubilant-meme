#!/usr/bin/env bash
set -x

source /etc/os-release

if [[ "${NAME}" != "Ubuntu" ]]; then
    dnf makecache -y
    dnf install -y sudo
else
    apt-get update -y
    apt-get install -yq sudo
fi
