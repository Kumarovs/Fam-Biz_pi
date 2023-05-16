#!/bin/bash

sudo apt-get update
sudo apt-get install docker.io docker-compose -y

sudo usermod -aG docker $USER
sudo mkdir ./DockerFiles/ContainerData/
sudo mkdir ./DockerFile/Downloads

FILE=docker-container-setup.sh
if test -f "$FILE"; then
    sudo rm"$FILE
fi

wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-container-setup.sh
sudo chmod +x docker-container-setup.sh
sudo ./docker-container-setup.sh
