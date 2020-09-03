#!/bin/bash

MAINNET_DIR=~/.shift-substrate/mainnet
TESTNET_DIR=~/.shift-substrate/testnet

setupMainnet() {
    mkdir -p $MAINNET_DIR
    createNodePeerKey $MAINNET_DIR
}

setupTestnet() {
    mkdir -p $TESTNET_DIR
    createNodePeerKey $TESTNET_DIR
}

createNodePeerKey() {
    DIR=$1

    if [[ -f "${DIR}/node-key" ]]; then
        echo "node-key file already exists!"
        echo -n "Would you like to delete and create a new one? (y/[n]): "
            read YESNO
        if [ "$YESNO" == "y" ] || [ -z "$YESNO" ]; then
            PEER_ID=$(subkey generate-node-key --file $DIR\\node-key)
            echo "Your public node peer id is: ${PEER_ID}"
        else
            PEER_ID=$(subkey inspect-node-key --file $DIR\\node-key)
            echo "Your pre-existing public node peer id is: ${PEER_ID}"
        fi
    else 
        PEER_ID=$(subkey generate-node-key --file $DIR\\node-key)
        echo "Your public node peer id is: ${PEER_ID}"
    fi
}

echo "Setting up persistant directories and files..."
echo -n "Please chooose: ShiftNrg mainnet (m) or testnet (t)? ([m]/t): "
    read NET_CHOICE
if [ "$NET_CHOICE" == "m" ] || [ -z "$NET_CHOICE" ]; then
        setupMainnet
    else
        setupTestnet
    fi