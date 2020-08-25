#!/bin/bash
# Author: Matt Swezey matt@shiftnrg.org
sudo apt install -y jq

useDocker() {
    if which docker > /dev/null
        then
            echo "Docker is installed...Will continue"
        else
            echo "Please install docker via './docker-install.sh' command"
            exit 1
    fi
    
    docker pull parity/subkey:2.0.0-rc6

    printf "Generating Aura Keys\n"
    SR25519=$(docker run parity/subkey:2.0.0-rc6 generate -n "shift" --scheme Sr25519 --output-type Json)
    echo $SR25519 | jq

    MNEMONIC=$(jq -r '.secretPhrase' <<< $SR25519)

    printf "Generating Granpa Keys...\n"
    #read -p 'Paste Mnemoic: ' mnemonic
    ED25519=$(docker run parity/subkey:2.0.0-rc6 inspect-key -n "shift" --scheme Ed25519 --output-type Json "$MNEMONIC")
    echo $ED25519 | jq
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
    printf "Generating Aura Keys (SR25519)\n"
    SR25519=$(subkey generate -n "shift" --scheme Sr25519 --output-type Json)
    echo $SR25519 | jq

    MNEMONIC=$(jq -r '.secretPhrase' <<< $SR25519)

    printf "Generating Granpa Keys (ED25519)\n"
    # read -p 'Paste Mnemoic: ' mnemonic
    ED25519=$(subkey inspect-key -n "shift" --scheme Ed25519 --output-type Json "$MNEMONIC")
    echo $ED25519 | jq
}

echo -n "Generate Keys using Docker (d) or Subkey (s)? ([d]/s) (Note: subkey must already be installed): "
read validatingOrNot

if [ "$validatingOrNot" == "d" ] || [ -z "$validatingOrNot" ]; then
    useDocker
else
    useSubkey
fi

printf "Now update the aura.json & gran.json files! (under ./keystore)\n"
printf "WIP - this will continue to be automated further. -Matt\n"