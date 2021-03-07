# shift-substrate
ShiftNrg's Substrate blockchain source code

### [Wiki](https://github.com/ShiftNrg/shift-substrate/wiki)
Please visit our Wiki page to find useful links, resources, terms to learn and more!

## Important Information
* This code has not launched a mainnet version!
* Keys generated during this phase should not be used on any mainnets! 

----

# Installation Steps
If you are setting up a fresh VPS, please first follow [this server setup guide below](https://github.com/ShiftNrg/shift-substrate#server-setup-guide) before continuing.

The following steps are currently working for both Ubuntu 18.04 and 20.04 versions.


### Update firewall settings

Run the following commands in sequence to allow the P2P port for your node:
```
ufw allow 30333

ufw enable

ufw reload
```
Press y when asked to enable firewall.


### Add sudo user

Run the following commands in sequence to create your new user:
```
adduser shift

usermod -aG sudo shift

visudo
```
Add this line to the bottom of the file: 
```
shift     ALL=(ALL) NOPASSWD:ALL
```  
Use [CTRL+X] [Y] to quit


### Update & install packages with sudo-user

Log in to the newly created shift sudo-user:
```
su - shift
```
Update and install packages by running the following command:
```
sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt install -y git curl
```

## Node installation
#### Do not install as `root`. Use the newly created sudo-user called `shift`!

Clone this repository and enter the directiory with the following command: 
```
git clone https://github.com/ShiftNrg/shift-substrate && cd shift-substrate
```
Run the install script with the following command (this can take up to 15-45 minutes, depending on your VPS's specifications):
```
./install.sh
```
You will be prompted to whether you want to install docker. Select option N: `No` as we won't be using it.

Generate new keys for your node with the following command:
```
./generateKeys.sh
```
This will prompt the user through some configuration steps. Recommend to use subkey!
   1. This script will ask you for mainnet (m) or testnet (t). Option t leads to a working chain for the time being.
   2. This script will ask if you're going to be a full node or validator. 
      * Answering v (validator) will lead to validator key set generation from a new mnemonic or existing one.
   3. This script will ask you if you're using subkey or docker.
      * Subkey is the current choice that leads to a successful node peer id key being generated and saved.

Setup the configuration and run the node as a service on your Ubuntu system with the following command:
```
./config.sh
```
This setups the configuration and runs the node as a service on your Ubuntu system:
   1. This script will ask if you're wanting to be a `validator` or `full node`. Answer accordingly. 
   2. This script will ask for you to enter your node name.
   3. This script enables and starts your validator/node! Check the sections belows.

### Validator Step Only!

Insert your keys (your node must be running!) with the following command:
```
./insertKeys.sh
```
Successful result output: `{"jsonrpc":"2.0","result":null,"id":1}`.

Restart your Validator with one of the following commands: 
```
sudo systemctl restart shift-substrate-validator.service

./restart.sh
```

#### Optional: bootstrap your validator node

Run the following script to bootstrap your validator to block 2,391,176 in several minutes:
```
./validatorBootstrap.sh
```

#### Optional: bootstrap your full node

Run the following script to bootstrap your full node to block 2,459,607 in several minutes:
```
./fullnodeBootstrap.sh
```

----

# Notes
* Allow port `30333` through your firewall if you haven't already. This is the default p2p port for nodes to communicate with each other
  * `sudo ufw allow 30333 && sudo ufw reload`

* The scripts will create a hidden folder `.shift-substrate` in your home directory
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
  
## Full Nodes
* Status check: `sudo systemctl status shift-substrate-node.service`
* Restarting your service: `sudo systemctl restart shift-substrate-node.service`
* Tail logs: `sudo journalctl -f -u shift-substrate-node.service`

## Key Creation
* Install Docker `./dockerInstall.sh` or already have subkey installed & compiled (takes forever!)
* Run `./generateKeys.sh`. Save the output of this command. Complete step 4 listed under `Validator Step Only!`

----

# Server setup guide

### Purchase a VPS from your favourite provider

* Minimum of 2 cores/4GB RAM/40G SSD space (more never hurts);
* Ubuntu 20.04 as operating system (or use 18.04 if preferred);
* Add your SSH-key in case you use those (recommended for security);
* Recommended specifications with sample compile times can be found [below this section](https://github.com/ShiftNrg/shift-substrate#recommend-vps-specs).


### Add swap space & set swappiness

Run the following commands in sequence:
```
fallocate -l 3G /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

echo '/swapfile none swap sw 0 0' >> /etc/fstab

echo 'vm.swappiness=20' >> /etc/sysctl.conf

sysctl vm.swappiness=20

tune2fs -m 1 /dev/sda1
```


### Secure your SSH access 

Open the SSH-configuration with the following command:
```
nano /etc/ssh/sshd_config
```
Find and change the following settings to (pick a new port for XXXXX, or leave as 22).
If you do not use [SSH keys](https://www.ssh.com/ssh/key/) to login, you can skip changing three of the settings.
Using SSH keys is recommended over using username & password, for security purposes.
```
Port XXXXX                                                 # not mandatory, but advised to change

LoginGraceTime 30s

PermitRootLogin no

MaxAuthTries 2

MaxSessions 2

PubkeyAuthentication yes                                   # only if you use SSH-keys

AuthorizedKeysFile     .ssh/authorized_keys                # only if you use SSH-keys

PasswordAuthentication no                                  # only if you use SSH-keys

PermitEmptyPasswords no

X11Forwarding no

MaxStartups 2
```
Restart SSH-service with the following command:
```
service ssh restart
```


### Update firewall settings

Run the following commands in sequence:
```
ufw allow XXXXX/tcp                                        # only if changed in SSH settings

ufw default deny incoming

ufw enable

ufw reload
```


### Add sudo user

Run the following commands in sequence:
```
adduser shift

usermod -aG sudo shift

visudo
```
Add this line to the bottom of the file: 
```
shift     ALL=(ALL) NOPASSWD:ALL
```  
Use [CTRL+X] [Y] to quit


### If using [SSH-keys](https://www.ssh.com/ssh/key/): copy .ssh folder to sudo user & set ownership

Run the following commands in sequence (skip if you do not use SSH-keys):
```
cp -rf .ssh /home/shift/.ssh                               # only if you use SSH-keys

chown -R shift:shift /home/shift/.ssh                      # only if you use SSH-keys
```

### Congratulations, your server is setup!

Continue with the [node installation steps](https://github.com/ShiftNrg/shift-substrate#installation-steps).

----

### Recommend VPS Specs
Minimum amount of RAM required: 2 GB
* 2 CPU core
* 2 GB RAM
* Ubuntu 20.04 or 18.04
  
* AWS EC2 Instances:
  * t3.small 2c/2GB
  * t3.medium 2c/4GB
  * t2.medium 2c/4GB

* Referral Links:
  * [Digital Ocean](https://m.do.co/c/2e7929d058d5) 
    * $15/mo - 2c/2GB 60GB SSD

### Sample Compile Times
This is from a fresh Ubuntu 18.04 instance

* DO - 2c/2GB/60GB SSD - `Finished release [optimized] target(s) in 43m 17s`
* AWS t3a.small - `Finished release [optimized] target(s) in 73m 52s` IE: t3a.small **not recommended**
* Private VM - 2c/2GB/SSD - `Finished release [optimized] target(s) in 42m 49s`
  * CPU - Ryzen 7 1700
