#!/bin/bash

installNode() {
    if which node > /dev/null
    then
        echo "Node is installed..."
        #TODO: test for version
    else
        sudo apt-get install build-essential libssl-dev -y
        
        printf "Installing NVM\n"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
        source ~/.bash_profile
        
        printf "Installing Node v12.13\n"
        nvm install 12.13
        
        printf "Using Node v12.13\n"
        nvm use 12.13
    fi
}