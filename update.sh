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
sudo rm -R ./chain # deprecated but needed for several rounds
sudo rm -R $VALIDATOR_DIR
sudo rm -R $FULLNODE_DIR

# Remove old submodule
sudo rm -R ./substrate-node

# back up keystore files
cp ./keystore/* ../

# reset changes
git reset --hard
git pull

# pull new submodules down
git submodule update --init --recursive  

# put key files back, delete temp copies
cp ../aura.json ./keystore/aura.json
cp ../gran.json ./keystore/gran.json
rm ../aura.json
rm ../gran.json

echo "Update complete. Please verify your keys in the /keystore"
echo "Make sure your SS58 Address starts with a number '3'"