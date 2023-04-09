#!/bin/bash

sudo apt-get update
sudo apt-get install docker.io docker-compose -y

sudo usermod -aG docker $USER
sudo mkdir ./DockerFiles/data/

read -p "Do you need to setup VPN? (y/n)" vpn_install_choice
if [ $vpn_install_choice = "y" ]; then
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

echo "Use the Zerotier One Network ID https://my.zerotier.com/ to connect to the VPN (it's 16 digits long ################)"
read -p "Enter the ZT ID digits:  " zerotierNetworkID

sudo zerotier-cli join $zerotierNetworkID
sleep 2

FILE=docker-container-setup.sh
if test -f "$FILE"; then
    sudo rm"$FILE
fi

wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-container-setup.sh
sudo chmod +x docker-container-setup.sh
sudo ./docker-container-setup.sh