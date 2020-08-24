#!/bin/bash

useDocker() {
    if which docker > /dev/null
        then
            echo "Docker is installed...Will continue"
        else
            echo "Please install docker via './docker-install.sh' command"
            exit 1
    fi

    printf "Generating Aura Keys\n"
    docker run parity/subkey:2.0.0-rc6 generate --scheme Sr25519

    printf "Generating Granpa Keys...\n"
    read -p 'Paste Mnemoic: ' mnemonic
    docker run parity/subkey:2.0.0-rc6 inspect-key --scheme Sr25519 "$mnemonic"

    printf "Now update the aura.json & gran.json files! (under ./keystore)\n"
    printf "WIP - this will continue to be automated further. -Matt\n"
}

useSubkey() {
    printf "Generating Aura Keys\n"
    subkey generate --scheme Sr25519

    printf "Generating Granpa Keys...\n"
    read -p 'Paste Mnemoic: ' mnemonic
    subkey inspect-key --scheme Sr25519 "$mnemonic"
}

echo -n "Generate Keys using Docker (d) or Subkey (s)? ([d]/s) (Note: subkey must already be installed): "
read validatingOrNot

if [ "$validatingOrNot" == "d" ] || [ -z "$validatingOrNot" ]; then
    useDocker
else
    useSubkey
fi

