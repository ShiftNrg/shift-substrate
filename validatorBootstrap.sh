#!/bin/bash
# Author: BFX

echo -n "Bootstrap your Validator node? ([y]/N) "
    read BOOTSTRAP
echo ""
if [ "$BOOTSTRAP" == "y" ] || [ -z "$BOOTSTRAP" ]; then
        sudo systemctl stop shift-substrate-validator.service
        printf "Downloading bootstrap, this may take several minutes..."
        cd ~/shift-substrate/validator-chain/chains/shift-testnet/
        sudo rm -rf db
        sudo git clone https://github.com/Bx64/shift-substrate-bootstrap db
        cd ~/shift-substrate
        sudo systemctl start shift-substrate-validator.service
    else
        exit 0
    fi
