#!/bin/bash
### Import script helpers ###
source ./scripts/color.sh

printf "${RED}Inserting AURA Key into your local node\n"
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@./keystore/aura.json"


printf "${RED}Inserting GRAN Key into your local node\n"
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@./keystore/gran.json"
