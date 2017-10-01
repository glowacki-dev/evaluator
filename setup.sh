#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script mus be run with root permissions"
    exit
fi

apt-get update
apt-get install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get install docker-ce

usermod -aG docker ${USER}

docker build -t 'compiler_machine' - < Dockerfile

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
chmod +x ${ROOT}/lib/runner.sh
