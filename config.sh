#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>
### Import script helpers ###
source ./scripts/color.sh

### CONFIGURATION ###

echo -n "Name your node (no spaces):"
    read NODE_NAME_INPUT
NODE_NAME="${NODE_NAME_INPUT}" # no spaces!

MAINNET_DIR=~/.shift-substrate/mainnet
TESTNET_DIR=~/.shift-substrate/testnet
NODE_KEY="node-key"
AURA=aura.json
GRAN=gran.json
TESTNET_SPEC="testnet.json"
MAINNET_SPEC="mainnet.json"
PEER_KEY=$TESTNET_DIR/$NODE_KEY

REPO_DIR="/home/$USER/shift-substrate"
VALIDATOR_DIR="$REPO_DIR/validator-chain"
FULLNODE_DIR="$REPO_DIR/fullnode-chain"
CHAIN_SPEC="$REPO_DIR/chain-spec/$TESTNET_SPEC"
SHIFT_NODE="$REPO_DIR/shift-substrate-core/target/release/shift-node"
#  "$(< file.txt)"
#  --node-key-file='$PEER_KEY'
### FUNCTIONS ###
createValidatorDaemonService() {
    sudo bash -c 'cat > /etc/systemd/system/shift-substrate-validator.service <<EOF
[Unit]
Description=ShiftNRG Validator

[Service]
WorkingDirectory='$REPO_DIR'

ExecStart='$SHIFT_NODE' --base-path '$VALIDATOR_DIR' --chain='$CHAIN_SPEC' --node-key="$(< '$PEER_KEY')" --port 30333 --ws-port 9944 --rpc-port 9933 --validator --rpc-methods=Unsafe --name "'$NODE_NAME'" --rpc-cors all
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
EOF'
}

createNodeDaemonService() {
    sudo bash -c 'cat > /etc/systemd/system/shift-substrate-node.service <<EOF
[Unit]
Description=ShiftNRG Node

[Service]
WorkingDirectory='$REPO_DIR'

ExecStart='$SHIFT_NODE' --base-path '$FULLNODE_DIR' --chain='$CHAIN_SPEC' --node-key-file='$PEER_KEY' --port 30333 --ws-port 9944 --rpc-port 9933  --name "'$NODE_NAME'"
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
EOF'
}

validatorOrNode() {
    echo -n "Validating (v) or Full Node (n)? ([v]/n): "
    read validatingOrNot

    if [ "$validatingOrNot" == "v" ] || [ -z "$validatingOrNot" ]; then
        createValidatorDaemonService
        sudo systemctl enable shift-substrate-validator.service
        sudo systemctl start shift-substrate-validator.service
    else
        createNodeDaemonService
        sudo systemctl enable shift-substrate-node.service
        sudo systemctl start shift-substrate-node.service
    fi
}

setupUbuntu() {
    printf "Enabling validator/node as a service...\n"
    validatorOrNode
}

### EXECUTION ###
printf "${RED}!!! WARNING !!! For testnet use only; potentially unsafe methods used. You've been warned!\n"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	set -e
	if [ -f /etc/redhat-release ]; then
		echo "Redhat Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1
	elif [ -f /etc/SuSE-release ]; then
		echo "Suse Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1
	elif [ -f /etc/arch-release ]; then
		echo "Arch Linux detected."
		export OPENSSL_LIB_DIR="/usr/lib/openssl-1.0";
		export OPENSSL_INCLUDE_DIR="/usr/include/openssl-1.0"
	elif [ -f /etc/mandrake-release ]; then
		echo "Mandrake Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1
	elif [ -f /etc/debian_version ]; then
		echo "Ubuntu/Debian Linux detected."
        setupUbuntu
	else
		echo "Unknown Linux distribution."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	set -e
	echo "${GREEN}Mac OS (Darwin) detected."
    echo "${YELLOW}WIP...come back later" #TODO
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "FreeBSD detected."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
	exit 1
else
	echo "Unknown operating system."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
	exit 1
fi

exit 0
