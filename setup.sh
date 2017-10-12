#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with root permissions"
    exit
fi

USER=$(who am i | awk '{print $1}')

apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common inotify-tools

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get install docker-ce

usermod -aG docker ${USER}

docker build --build-arg UID=$(id ${USER} -u) --build-arg GID=$(id ${USER} -g) -t 'compiler_machine' - < Dockerfile

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
chmod +x ${ROOT}/lib/runner.sh ${ROOT}/store/default/run.sh
mkdir -p ${ROOT}/store/code

echo "Docker setup successfully. To use docker without sudo you have to log out and log back in!"
echo "You can then install Ruby and required gems, and you can execute rackup to start the server."
