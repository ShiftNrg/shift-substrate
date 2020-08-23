#!/bin/bash
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
printf "${RED}Install Script: ShiftNRG's Substrate Node\n"
printf "Intstalling prerquisites...\n"
curl https://getsubstrate.io -sSf | bash -s -- --fast

printf "Initialize WebAssembly build env...\n"
source ~/.cargo/env
# Update Rust
rustup update nightly
rustup update stable
# Add Wasm target
rustup target add wasm32-unknown-unknown --toolchain nightly

printf "This may take 20+ minutes: Compiling ShiftNRG Substrate Code...\n"
cd substrate-node/
cargo build --release
cd ..

printf "Install node_modules for front-end app...\n"
installNode
npm install -g yarn
cd substrate-front-end/
yarn install

printf "${YELLOW}Proceed to to launch \`./config.sh\` after editing the file\n"

exit 0