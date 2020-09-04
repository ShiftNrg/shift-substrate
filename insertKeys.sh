#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>
### Import script helpers ###
source ./scripts/color.sh

MAINNET_DIR=~/.shift-substrate/mainnet
TESTNET_DIR=~/.shift-substrate/testnet
AURA=aura.json
GRAN=gran.json

echo -n "Please chooose: ShiftNrg mainnet (m) or testnet (t)? ([m]/t): "
    read NET_CHOICE
echo ""
if [ "$NET_CHOICE" == "m" ] || [ -z "$NET_CHOICE" ]; then
        DIR=$MAINNET_DIR
    else
        DIR=$TESTNET_DIR
    fi

printf "${RED}Inserting AURA Key into your local node\n"
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@${DIR}/${AURA}"


printf "${RED}Inserting GRAN Key into your local node\n"
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@${DIR}/${GRAN}"
