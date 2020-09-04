#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>

MAINNET_DIR=~/.shift-substrate/mainnet
TESTNET_DIR=~/.shift-substrate/testnet
NODE_KEY="node-key"
ADDRESS_TYPE="-n shift"
AURA=aura.json
GRAN=gran.json

V_F=""
CONTENT=""
DIR=""

saveAuraKeys() {
    cat > ${DIR}/${AURA} <<EOF
{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_insertKey",
    "params": [
      "aura",
      "${MNEMONIC}",
      "${SR_PUB_KEY}"
    ]
}

EOF
}

saveGranKeys() {
    cat > ${DIR}/${GRAN} <<EOF
{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_insertKey",
    "params": [
      "gran",
      "${MNEMONIC}",
      "${ED_PUB_KEY}"
    ]
}

EOF
}

useDocker() {
    if which docker > /dev/null
        then
            echo "Docker is installed...This is the way"
        else
            echo "Please install docker via './dockerInstall.sh' command"
            exit 1
    fi

    docker pull parity/subkey:2.0.0-rc6

    if [ "$NODE_CHOICE" == "f" ] || [ -z "$NODE_CHOICE" ]; then
        :
    else
        printf "Generating Aura Keys\n"
        SR25519=$(docker run parity/subkey:2.0.0-rc6 generate -n "shift" --scheme Sr25519 --output-type Json)
        echo $SR25519 | jq

        MNEMONIC=$(jq -r '.secretPhrase' <<< $SR25519)
        SR_PUB_KEY=$(jq -r '.publicKey' <<< $SR25519)
        SR_ADDRESS=$(jq -r '.ss58Address' <<< $SR25519)

        printf "Generating Granpa Keys...\n"
        #read -p 'Paste Mnemoic: ' mnemonic
        ED25519=$(docker run parity/subkey:2.0.0-rc6 inspect-key -n "shift" --scheme Ed25519 --output-type Json "$MNEMONIC")
        echo $ED25519 | jq

        ED_PUB_KEY=$(jq -r '.publicKey' <<< $ED25519)
        ED_ADDRESS=$(jq -r '.ss58Address' <<< $ED25519)

        saveAuraKeys
        saveGranKeys
    fi

    echo "Generating Peer ID Key..Error.."
    echo "Docker image is support this feature. Error has been reported already."
    echo "Please install subkey or continue and grob your peer ID from the logs."
    # awaiting fix: https://github.com/paritytech/substrate/issues/7022
    # PEER_ID=$(docker run parity/subkey:2.0.0-rc6 generate-node-key --file ${DIR}/${NODE_KEY})
    # echo "Your NEW public node peer id is: ${PEER_ID}"
}

useSubkey() {
    if which subkey > /dev/null
        then
            echo "Subkey is installed...Will continue"
        else
            echo "Please install subkey and run again"
            echo "'cargo install --force --git https://github.com/paritytech/substrate subkey'"
            exit 1
    fi

    if [ "$NODE_CHOICE" == "f" ] || [ -z "$NODE_CHOICE" ]; then
        :
    else
        printf "Generating Aura Keys (SR25519)\n"
        SR25519=$(subkey generate -n "shift" --scheme Sr25519 --output-type Json)
        echo $SR25519 | jq

        MNEMONIC=$(jq -r '.secretPhrase' <<< $SR25519)
        SR_PUB_KEY=$(jq -r '.publicKey' <<< $SR25519)
        SR_ADDRESS=$(jq -r '.ss58Address' <<< $SR25519)

        printf "Generating Granpa Keys (ED25519)\n"
        # read -p 'Paste Mnemoic: ' mnemonic
        ED25519=$(subkey inspect-key -n "shift" --scheme Ed25519 --output-type Json "$MNEMONIC")
        echo $ED25519 | jq

        ED_PUB_KEY=$(jq -r '.publicKey' <<< $ED25519)
        ED_ADDRESS=$(jq -r '.ss58Address' <<< $ED25519)

        saveAuraKeys
        saveGranKeys
    fi

    # echo "Generating Peer ID Key"
    # PEER_ID=$(subkey generate-node-key --file $DIR/$NODE_KEY)
    # echo "Your NEW public node peer id is: ${PEER_ID}"


    if [[ -f "${DIR}/${NODE_KEY}" ]]; then
        echo "node-key file already exists!"
        echo -n "Would you like to delete and create a new one? (y/[n]): "
            read YESNO
        if [ "$YESNO" == "y" ] || [ -z "$YESNO" ]; then
            PEER_ID=$(subkey generate-node-key --file $DIR/$NODE_KEY)
            echo "Your NEW public node peer id is: ${PEER_ID}"
        else
            PEER_ID=$(subkey inspect-node-key --file ${DIR}/${NODE_KEY})
            echo "Your pre-existing public node peer id is: ${PEER_ID}"
        fi
    else 
        PEER_ID=$(subkey generate-node-key --file $DIR/$NODE_KEY)
        echo "Your NEW public node peer id is: ${PEER_ID}"
    fi
}

# User questions for key configuration
echo -n "Please chooose: ShiftNrg mainnet (m) or testnet (t)? ([m]/t): "
    read NET_CHOICE
echo ""
echo -n "Are you setting up a (f) Full Node or (v) Validator? ([f]/v)"
    read NODE_CHOICE
echo ""
echo -n "Are you using (d) docker or (s) subkey? ([d]/s)"
    read DOCKER_CHOICE
echo ""
echo -n "Do you have your own mnemonic phrase? (y/[n])"
    read MNEMONIC_CHOICE
if [ "$MNEMONIC_CHOICE" == "y" ] || [ -z "$MNEMONIC_CHOICE" ]; then
        echo "Not Supported: WIP"
        # echo -n "Enter your mnemonic: "
            # read OWN_MNEMONIC
    else
        :
    fi


if [ "$NET_CHOICE" == "m" ] || [ -z "$NET_CHOICE" ]; then
        DIR=$MAINNET_DIR
    else
        DIR=$TESTNET_DIR
    fi

echo "Setting up persistant directory... $DIR"
mkdir -p $DIR

if [ "$DOCKER_CHOICE" == "d" ] || [ -z "$DOCKER_CHOICE" ]; then
        useDocker 
    else
        useSubkey
    fi

echo "Files saved under ${DIR}"
echo "Backup these files in a secure, encrypted location"