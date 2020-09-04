# shift-substrate
ShiftNrg's Substrate blockchain source code

### [Wiki](https://github.com/ShiftNrg/shift-substrate/wiki)

## Important Information
* This code has not launched a mainnet version!
* Keys generated during this phase should not be used on any mainnets! 

## Installation Steps
These steps are currently working for an opinionated Ubuntu 18.04 install. Other OS Support coming later.

1. run `./install.sh` # this will take up to 15-30 minutes pending your system's specs
2. `nano ./config.sh` # Update `NODE_NAME` (Line 6) to your liking 
3. run `./config.sh` # this setups the configuration and runs the node as a service on your Ubuntu system
   1. This script will ask if you're wanting to be a `validator` or `full node`. Answer accordingly. 
   2. This script enables and starts your validator/node! Check the sections belows
4. **Validator Step Only!** Update the `./keystore/aura.json` & `./keystore/gran.json` files with your `mnemonic phrase` key and `public key`
   1. Run `./insert-keys.sh`. Note: node must be running!
   2. Successful result output: `{"jsonrpc":"2.0","result":null,"id":1}`
   3. Restart your Validator! `sudo systemctl restart shift-substrate-validator.service`

# Notes
* allow port `30333` through your firewall. This is the default p2p port for nodes to communicate with each other
  * `sudo ufw allow 30333 && sudo ufw reload`

* the scripts will create a hidden folder `.shift-substrate` in your home directory
  * it will also create either a `mainnet` or `testnet` folder under this hidden directory
    * in these folders sensitive information is stored! Secure your servers!
      * `node-key` containts the private key for your node to generate it's public peer id
        * you see your node's peer id in the logs when your start/restart the service
      * `aura.json` contains your AURA secrets
      * `gran.json` containt your GRANDPA secrets

## Validators
* Status check: `sudo systemctl status shift-substrate-validator.service`
* Restarting your service: `sudo systemctl restart shift-substrate-validator.service`
* Tail logs: `sudo journalctl -f -u shift-substrate-validator.service`
  
### Key Creation
* Install Docker `./docker-install.sh` or already have subkey installed & compiled (takes forever!)
* Run `./generateKeys.sh`. Save the output of this command. Complete step 4 listed under `Validator Step Only!`

## Full Nodes
* Status check: `sudo systemctl status shift-substrate-node.service`
* Restarting your service: `sudo systemctl restart shift-substrate-node.service`
* Tail logs: `sudo journalctl -f -u shift-substrate-node.service`

## Recommend VPS Specs
Minimum amount of RAM required: 2 GB
* 2 CPU core
* 2 GB RAM
* Ubuntu 18.04
  
* AWS EC2 Instances:
  * t3.small 2c/2GB
  * t3.medium 2c/4GB
  * t2.medium 2c/4GB

* Referral Links:
  * [Digital Ocean](https://m.do.co/c/2e7929d058d5) 
    * $15/mo - 2c/2GB 60GB SSD

## Sample Compile Times
This is from a fresh Ubuntu 18.04 instance

* DO - 2c/2GB/60GB SSD - `Finished release [optimized] target(s) in 43m 17s`
* AWS t3a.small - `Finished release [optimized] target(s) in 73m 52s` IE: t3a.small **not recommended**
* Private VM - 2c/2GB/SSD - `Finished release [optimized] target(s) in 42m 49s`
  * CPU - Ryzen 7 1700
