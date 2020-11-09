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

### START ####
printf "${RED}Install Script: ShiftNrg's Substrate Node\n"
printf "Intstalling prerquisites...\n"
curl https://getsubstrate.io -sSf | bash -s -- --fast

printf "Initialize WebAssembly build env...\n"
source ~/.cargo/env
# Update Rust
rustup update nightly
rustup update stable
rustup install nightly-2020-10-06
# Add Wasm target
rustup target add wasm32-unknown-unknown --toolchain nightly-2020-10-06

printf "This may take 20+ minutes: Compiling ShiftNrg Substrate Code...\n"
cd shift-substrate-core/
WASM_BUILD_TOOLCHAIN=nightly-2020-10-06 cargo build --release
cd ..

if which jq > /dev/null
    then
        :
    else
        sudo apt install -y jq
fi

if which docker > /dev/null
    then
        echo "Docker is already installed, skipping"
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
