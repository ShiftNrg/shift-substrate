#!/bin/bash

# back up keystore files
cp ./keystore/* ../

# reset changes
git reset --hard
git pull

# pull new submodules down
git submodule update --init --recursive  

cp ../aura.json ./keystore/aura.json
cp ../gran.json ./keystore/gran.json