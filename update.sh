#!/bin/bash
echo "stoping services"
sudo systemctl stop shift-substrate-validator.service
sudo systemctl stop shift-substrate-node.service

echo ""
echo "purging chain folder"
sudo rm -R ./chain
sudo rm -R ./validator-chain
sudo rm -R ./fullnode-chain

echo ""
echo "error messages above are expected in most cases; safe to ignore"

echo ""
echo "Full Node Operaters please run this command:"
echo "'sudo systemctl start shift-substrate-node.service'"
echo ""

echo "Validators please run these 3 commands:"
echo "'sudo systemctl start shift-substrate-validator.service'"
echo ""
echo "Wait 5-20s for it to start..."
echo ""
echo "then:"
echo "'./insert-keys.sh'"
echo ""
echo "then:"
echo "'sudo service shift-substrate-validator restart'"