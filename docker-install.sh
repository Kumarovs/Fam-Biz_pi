
sudo apt-get update
sudo apt-get install docker.io docker-compose -y

sudo usermod -aG docker $USER
sudo mkdir ./DockerFiles/data/

sudo rm docker-container-setup.sh
wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-container-setup.sh
sudo chmod +x docker-container-setup.sh
sudo ./docker-container-setup.sh