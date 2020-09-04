#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>

if which docker > /dev/null
    then
        echo "Docker is already installed"
    else
        echo "Installing Docker... One moment please..."
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
        sudo apt update
        apt-cache policy docker-ce
        sudo apt install -y docker-ce
        echo "Docker setup complete! 💯"
fi

getent group docker || groupadd docker
sudo usermod -aG docker ${USER}
echo "Attempt command `docker ps`; if it fails, logout and back into your server"
printf "To uninstall docker run: 'sudo apt-get remove docker docker-engine docker.io containerd runc docker-ce-cli'\n"
exit 0