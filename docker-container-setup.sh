#!/bin/bash

echo "Please choose a container to install:"
echo "1. Pi-hole"
echo "2. Nginx"
echo "3. MariaDB"
echo "4. Redis"
read -p "Enter the number of the container you want to install: " container_choice

TZ="Europe/Riga"

if [ $container_choice -eq 1 ]; then
  read -p "Enter the password for the Pi-hole web interface: " WEBPASSWORD
elif [ $container_choice -eq 2 ]; then
  : 
elif [ $container_choice -eq 3 ]; then
  read -p "Enter the root password for the MariaDB database: " MYSQL_ROOT_PASSWORD
elif [ $container_choice -eq 4 ]; then
  : 
else
  echo "Invalid choice. Exiting."
  exit 1
fi

if [ $container_choice -eq 1 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  pihole:
    image: pihole/pihole:latest
    container_name: pihole
    environment:
      TZ: "$TZ"
      WEBPASSWORD: "$WEBPASSWORD"
    ports:
      - "80:80"
      - "53:53/tcp"
      - "53:53/udp"
    volumes:
      - "./DockerFiles/data/pihole:/etc/pihole"
      - "./DockerFiles/data/dnsmasq.d:/etc/dnsmasq.d"
EOF
elif [ $container_choice -eq 2 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    environment:
      TZ: "$TZ"
    ports:
      - "80:80"
    volumes:
      - "./DockerFiles/data/nginx/conf.d:/etc/nginx/conf.d"
      - "./DockerFiles/data/nginx/html:/usr/share/nginx/html"
EOF
elif [ $container_choice -eq 3 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  mariadb:
    image: mariadb:latest
    container_name: mariadb
    environment:
      TZ: "$TZ"
      MYSQL_ROOT_PASSWORD: "$MYSQL_ROOT_PASSWORD"
    volumes:
      - "./DockerFiles/data/mariadb:/var/lib/mysql"
EOF

docker-compose up -d
read -p "Install another container? (y/n)" container_install_choice
if [ $container_install_choice -eq "y" ]; then
./docker-container-setup.sh
elif [ $container_install_choice -eq "n" ]; then
exit
exit