#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>
### Import script helpers ###
source ./scripts/color.sh
source ./scripts/node-install.sh

## CHECKOUT GIT COMMITS ## Not needed - REMOVE ME
# printf "${BLUE}Checkout v2.0.0-rc6 via commit hash\n"
# cd substrate-node/
# git checkout c9fda53e31bd9d755aa057a04ba7e80fd13e4d6e   
# cd ..

# cd substrate-front-end/
# git checkout 0252e7a3998036209d159ec437e19493519d9c41
# cd ..

## Pull down submodules code
git submodule update --init --recursive


## Check if running as root
if [[ $EUID -eq 0 ]]; then
    printf "${RED}This script should not be run using sudo or as root. Please run it as a regular user.\n"
    exit 1
fi

## Check if we are ok with dispace
MINSPACE=`df -k --output=avail "$PWD" | tail -n1`

# We can adjust requirement here. ex 20GB
if [[ $MINSPACE -lt 21474825 ]]; then
    printf "${RED}Not enough free space in $PWD to install Substrade Node.\n"
    exit 1
fi

# Check if ntp is installed running
if sudo pgrep -x "ntpd" > /dev/null; then
    printf "NTP is running"
else
    echo "${RED} NTP is not running"
       
    read -r -n 1 -p "Would like to install NTP? (y/n): " REPLY
    
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        printf "Installing NTP...\n"
        sudo apt-get install ntp ntpdate -yyq
        sudo service ntp stop
        sudo ntpdate pool.ntp.org
        sudo service ntp start
               
        if sudo pgrep -x "ntpd" > /dev/null; then
            printf "NTP is running\n"
        else
            printf "${RED}Problem starting NTP service Please check /etc/ntp.conf and correct any issues."
            exit 0
        fi
    else
        printf "${RED}Substrade node requires NTP, exiting."
        exit 0
    fi
fi

### START ####
printf "${RED}Install Script: ShiftNrg's Substrate Node\n"
printf "Installing prequisites...\n"
curl https://sh.rustup.rs/ -sSf | sh -s -- -y
sudo apt install -y make clang libclang-dev pkg-config libssl-dev cmake gcc build-essential jq curl

printf "Initialize WebAssembly build env...\n"
source ~/.cargo/env
# Update Rust
rustup update nightly
rustup update stable
rustup install nightly-2020-10-06
rustup default nightly-2020-10-06
# Add Wasm target
rustup target add wasm32-unknown-unknown --toolchain nightly-2020-10-06-x86_64-unknown-linux-gnu
# Install subkey
printf "This may take 10+ minutes: Compiling subkey...\n"
cargo install --force subkey --git https://github.com/paritytech/substrate --version 2.0.0 --locked

printf "This may take 20+ minutes: Compiling ShiftNrg Substrate Code...\n"
cd shift-substrate-core/
cargo build --release
cd ..

if which docker > /dev/null
    then
        printf "Docker is already installed, skipping\n"
    else
        echo -n "Would you like to install docker? ([y]/n) "
            read DOCKER_CHOICE
        if [ "$DOCKER_CHOICE" == "y" ] || [ -z "$DOCKER_CHOICE" ]; then
            bash dockerInstall.sh
        fi
fi

printf "Install node_modules for front-end app...\n"
# installNode
# npm install -g yarn
# cd substrate-front-end/
# yarn install

printf "${YELLOW}Proceed to launch \`./generateKeys.sh\`\n"
exit 0
