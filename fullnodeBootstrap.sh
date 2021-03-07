#!/bin/bash
# Author: BFX

echo -n "Bootstrap your Full node? ([y]/N) "
    read BOOTSTRAP
echo ""
if [ "$BOOTSTRAP" == "y" ] || [ -z "$BOOTSTRAP" ]; then
        sudo systemctl stop shift-substrate-node.service
        printf "Downloading bootstrap, this may take a short while..."
        cd ~/shift-substrate/fullnode-chain/chains/shift-testnet/
        git clone https://github.com/Bx64/shift-substrate-bootstrap-fullnode db
        cd ~/shift-substrate
        sudo systemctl start shift-substrate-node.service
    else
        exit 0
    fi
