#!/bin/bash

echo "Please choose a container to install:"
echo "1. Adguard"
echo "5. Home Assistant for Raspberry Pi"
echo "6. Nextcloud for Raspberry Pi"
echo "7. Vaultwarden"
echo "9. Uptime Kuma"
echo "10. QBittorrent"
echo "11. Duplicati"
echo "12. Lychee for Photos"
echo "13. Speedtest-Tracker"
echo "16. Mealie"
echo "17. Paperless NG"
echo "19. Grocy"
echo "20. PhotoPrism"
echo "21. Dozzle"
echo "23. Filebrowser"
read -p "Enter the number of the container you want to install: " container_choice

TZ="Europe/Riga"

if [ $container_choice -eq 1 ]; then
:
elif [ $container_choice -eq 2 ]; then
:
elif [ $container_choice -eq 3 ]; then
read -p "Enter the root password for the MariaDB database: " MYSQL_ROOT_PASSWORD
elif [ $container_choice -eq 4 ]; then
:
elif [ $container_choice -eq 5 ]; then
:
elif [ $container_choice -eq 6 ]; then
:
elif [ $container_choice -eq 7 ]; then
:
elif [ $container_choice -eq 8 ]; then
:
elif [ $container_choice -eq 9 ]; then
:
elif [ $container_choice -eq 10 ]; then
:
elif [ $container_choice -eq 11 ]; then
:
elif [ $container_choice -eq 12 ]; then
:
elif [ $container_choice -eq 13 ]; then
:
elif [ $container_choice -eq 14 ]; then
:
elif [ $container_choice -eq 15 ]; then
:
elif [ $container_choice -eq 16 ]; then
:
elif [ $container_choice -eq 17 ]; then
:
elif [ $container_choice -eq 18 ]; then
:
elif [ $container_choice -eq 19 ]; then
:
elif [ $container_choice -eq 20 ]; then
:
elif [ $container_choice -eq 21 ]; then
:
elif [ $container_choice -eq 22 ]; then
:
elif [ $container_choice -eq 23 ]; then
:
else
echo "Invalid choice. Exiting."
exit 1
fi

if [ $container_choice -eq 1 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: Adguardhome
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "68:68/tcp"
      - "68:68/udp"
      - "8081:80/tcp"
      - "443:443/tcp"
		  - "443:443/udp",
		  - "3001:3000/tcp",
		  - "853:853/tcp",
		  - "784:784/udp",
		  - "853:853/udp",
		  - "8853:8853/udp",
		  - "5443:5443/tcp",
		  - "5443:5443/udp"
    volumes:
      - ./DockerFiles/ContainerData/AdguardHome/config:/opt/adguardhome/conf
      - ./DockerFiles/ContainerData/AdguardHome/work:/opt/adguardhome/work
    environment:
      TZ: "$TZ"
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
      - "./DockerFiles/ContainerData/nginx/conf.d:/etc/nginx/conf.d"
      - "./DockerFiles/ContainerData/nginx/html:/usr/share/nginx/html"
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
      - "./DockerFiles/ContainerData/mariadb:/var/lib/mysql"
EOF
elif [ $container_choice -eq 4 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  redis:
    image: redis:latest
    container_name: redis
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/ContainerData/redis:/data"
EOF
elif [ $container_choice -eq 5 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  homeassistant:
    image: homeassistant/raspberrypi4-homeassistant:latest
    container_name: homeassistant
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/ContainerData/homeassistant:/config"
EOF
elif [ $container_choice -eq 6 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  nextcloud:
    image: linuxserver/nextcloud:latest
    container_name: nextcloud
    environment:
      TZ: "$TZ"
    volumes:
      - "$NEXTCLOUD_DATA_PATH:/data"
      - "$NEXTCLOUD_CONFIG_PATH:/config"
EOF
elif [ $container_choice -eq 7 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/ContainerData/vaultwarden:/data"
EOF
elif [ $container_choice -eq 8 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  heimdall:
    image: linuxserver/heimdall:latest
    container_name: heimdall
    environment:
      TZ: "$TZ"
    volumes:
      - "$HEIMDALL_DATA_PATH:/config"
EOF
elif [ $container_choice -eq 9 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  uptimerobot:
    image: linuxserver/uptimerobot:latest
    container_name: uptimerobot
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/ContainerData/uptimerobot:/config"
EOF
elif [ $container_choice -eq 10 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  qbittorrent:
    image: linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/ContainerData/qbittorrent:/config"
      - "./DockerFiles/Downloads/:/downloads"
EOF
elif [ $container_choice -eq 11 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  duplicati:
    image: linuxserver/duplicati:latest
    container_name:duplicati
    environment:
      TZ: "$TZ"
    volumes:
      "$DUPLICATI_CONFIG_PATH:/config"
      "$DUPLICATI_DATA_PATH:/source"
      "$DUPLICATI_BACKUP_PATH:/backup"
EOF
elif [ $container_choice -eq 12 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  lychee:
    image: linuxserver/lychee:latest
    container_name: lychee
    environment:
      TZ: "$TZ"
    volumes:
      "$LYCHEE_CONFIG_PATH:/config"
      "$LYCHEE_PHOTOS_PATH:/pictures"
EOF
elif [ $container_choice -eq 13 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  speedtest:
    image: henrywhitaker3/speedtest-tracker:latest-arm
    container_name: speedtest
    ports:
        - 8765:80
    volumes:
        - /portainer/Files/AppData/Config/speedtest-tracker/config:/config
    environment:
        - TZ="$TZ"
        - PGID=
        - PUID=
        - OOKLA_EULA_GDPR=true
    logging:
        driver: "json-file"
        options:
            max-file: "10"
            max-size: "200k"
    restart: unless-stopped
EOF
elif [ $container_choice -eq 14 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  deluge:
    image: linuxserver/deluge:latest
    container_name: deluge
    environment:
      TZ: "$TZ"
    volumes:
      "$DELUGE_CONFIG_PATH:/config"
      "$DELUGE_DOWNLOAD_PATH:/downloads"
      "$DELUGE_WATCH_PATH:/watch"
EOF
elif [ $container_choice -eq 15 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  transmission:
    image: linuxserver/transmission:latest
    container_name: transmission
    environment:
      TZ: "$TZ"
    volumes:
      "$TRANSMISSION_CONFIG_PATH:/config"
      "$TRANSMISSION_DOWNLOAD_PATH:/downloads"
      "$TRANSMISSION_WATCH_PATH:/watch"
EOF
elif [ $container_choice -eq 16 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  mealie:
    image: berrnd/mealie:latest
    container_name: mealie
    environment:
      TZ: "$TZ"
    volumes:
      "$MEALIE_CONFIG_PATH:/app/config"
EOF
elif [ $container_choice -eq 17 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  paperless:
    image: paperlessng/paperless:latest
    container_name: paperless
    environment:
      TZ: "$TZ"
    volumes:
      "$PAPERLESS_DATA_PATH:/srv/paperless"
EOF
elif [ $container_choice -eq 18 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  nginx-proxy-manager:
    image: jlesage/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    environment:
      TZ: "$TZ"
    volumes:
      "$NGINX_PROXY_MANAGER_DATA_PATH:/config"
      "$NGINX_PROXY_MANAGER_LETSENCRYPT_PATH:/etc/letsencrypt"
    ports:
      "80:80"
      "443:443"
EOF
elif [ $container_choice -eq 19 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  grocy:
    image: linuxserver/grocy:latest
    container_name: grocy
    environment:
      TZ: "$TZ"
    volumes:
      "$GROCY_CONFIG_PATH:/config"
EOF
elif [ $container_choice -eq 20 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  photoprism:
    image: photoprism/photoprism:latest
    container_name: photoprism
    environment:
      TZ: "$TZ"
    volumes:
      "$PHOTOPRISM_CONFIG_PATH:/photoprism"
      "$PHOTOPRISM_IMPORT_PATH:/import"
      "$PHOTOPRISM_ORIGINALS_PATH:/originals"
      "$PHOTOPRISM_CACHE_PATH:/cache"
    ports:
      - "2342:2342"
EOF
elif [ $container_choice -eq 21 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  dozzle:
    image: amir20/dozzle:latest
    container_name: dozzle
    environment:
      DOZZLE_LOG_FILES: "$DOZZLE_LOG_FILES"
      DOZZLE_TITLE: "$DOZZLE_TITLE"
      DOZZLE_LOG_FORMAT: "$DOZZLE_LOG_FORMAT"
      DOZZLE_ENABLE_AUTH: "$DOZZLE_ENABLE_AUTH"
      DOZZLE_USERNAME: "$DOZZLE_USERNAME"
      DOZZLE_PASSWORD: "$DOZZLE_PASSWORD"
      DOZZLE_PORT: "$DOZZLE_PORT"
      DOZZLE_THEME: "$DOZZLE_THEME"
      DOZZLE_REVERSE_PROXY: "$DOZZLE_REVERSE_PROXY"
      DOZZLE_LOG_STREAM: "$DOZZLE_LOG_STREAM"
    ports:
      - "$DOZZLE_PORT:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
EOF
elif [ $container_choice -eq 22 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  samba:
    image: dperson/samba:latest
    container_name: samba
    environment:
      TZ: "$TZ"
      SAMBA_WORKGROUP: "$SAMBA_WORKGROUP"
      SAMBA_SHARE_NAME: "$SAMBA_SHARE_NAME"
      SAMBA_SHARE_COMMENT: "$SAMBA_SHARE_COMMENT"
      SAMBA_SHARE_PATH: "$SAMBA_SHARE_PATH"
      SAMBA_SHARE_READONLY: "$SAMBA_SHARE_READONLY"
      SAMBA_USER: "$SAMBA_USER"
      SAMBA_PASSWORD: "$SAMBA_PASSWORD"
    ports:
      - "139:139"
      - "445:445"
    volumes:
      - "$SAMBA_SHARE_PATH:/mnt/share"
    restart: unless-stopped
EOF
elif [ $container_choice -eq 23 ]; then
  cat > docker-compose.yml << EOF
version: '3'
services:
  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: filebrowser
    environment:
      TZ: "$TZ"
      FB_AUTH_METHOD: "$FB_AUTH_METHOD"
      FB_AUTH_USERS: "$FB_AUTH_USERS"
      FB_LOG_LEVEL: "$FB_LOG_LEVEL"
      FB_PORT: "$FB_PORT"
      FB_BASEURL: "$FB_BASEURL"
    volumes:
      - "$FILEBROWSER_ROOT:/srv"
    ports:
      - "$FB_PORT:80"
EOF
else
  echo "Invalid choice. Exiting."
exit 1
fi

docker-compose up -d
read -p "Install another container? (y/n)" container_install_choice
if [ $container_install_choice = "y" ]; then
./docker-container-setup.sh
elif [ $container_install_choice = "n" ]; then
exit
fi
exit
