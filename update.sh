#!/bin/bash
### CONFIGURATION ###
REPO_DIR="/home/$USER/shift-substrate"
VALIDATOR_DIR="$REPO_DIR/validator-chain"
FULLNODE_DIR="$REPO_DIR/fullnode-chain"
CHAIN_SPEC="$REPO_DIR/chain-spec/$TESTNET"
NODE_TEMPLATE="$REPO_DIR/shift-substrate-core/target/release/shift-node"

# Stop validator | node
sudo systemctl stop shift-substrate-validator.service
sudo systemctl stop shift-substrate-node.service

# Remove chain folder
sudo rm -R VALIDATOR_DIR
sudo rm -R FULLNODE_DIR

# Remove old submodule
sudo rm -R ./substrate-node

# back up keystore files
cp ./keystore/* ../

# reset changes
git reset --hard
git pull

# pull new submodules down
git submodule update --init --recursive  

cp ../aura.json ./keystore/aura.json
cp ../gran.json ./keystore/gran.json