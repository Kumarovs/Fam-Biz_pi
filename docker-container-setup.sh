#!/bin/bash
clear

NC='\033[0m' 
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'

echo ""
echo -e "${YELLOW}1. Noņemt konteineri${NC}"
echo -e "${YELLOW}2. Instalēt konteineri${NC}"
echo -e "${YELLOW}3. Iziet${NC}"
read -p "Ievadiet izvēles ciparu: " choice_task

if [ $choice_task -eq 3 ]; then
  exit
elif [ $choice_task -eq 1 ]; then
  echo -e "${BLUE}Šobrīd ejošie konteineri:${NC}"
  docker ps --format "{{.Names}}"
  echo "====================="
  read -p "Ievadiet precīzi konteinera nosaukumu, kuru vēlaties noņemt: " container_name

  docker stop "$container_name"
  docker rm "$container_name"
  clear
  ./docker-container-setup.sh
elif [ $choice_task -eq 2 ]; then

  echo -e "${BLUE}Izvēlamies pieejamos konteinerus:${NC}"
  echo "1. Adguard (DNS ar iebūvētu reklāmu bloķētāju)"
  echo "2. JDownloader 2 (Lejupielādē uz servera lielapjoma failus)"
  echo "3. Dozzle (Servera diagnostikas rīks)"
  echo "4. PhotoPrism (Foto/Video galerija, jābūt vismaz 4GB RAM!!!)"
  echo "5. Home Assistant (Gudrās mājas asistents)"
  echo "6. Nextcloud for Raspberry Pi (Google produktu alternatīva)"
  echo "7. VaultWarden (Paroļu krātuve)"
  echo "8. Heimdall (Rediģējama servera sākuma lapa)"
  echo "9. Uptime Kuma (Tīmekļvietņu darbspējas laika mērītājs)"
  echo "10. Homarr (Rediģējama mājaslapa ar visiem uzinstalētajiem servera servisiem)"
  echo "11. Duplicati (Datu rezervju veidotājs)"
  echo "12. Lychee for Photos (Foto/Video galerija)"
  echo "13. Speedtest-Tracker (Interneta ātruma mērītājs)"
  echo "14. File Browser (Servera lokālās krātuves rediģētājs analogs Google Drive)"
  echo "15. PiGallery2 (Foto/Video galerija mazāk jaudīgiem serveriem)"
  echo "16. Mealie (Recepšu pārvaldnieks)"
  echo "17. Paperless-ngx (Papīra dokumentu digitalizētājs)"
  echo "18. Traefik (Servera rīks - ļauj nenorādīt uzinstalētā servisa portu, bet gan nosaukumu)"
  echo "19. Grocy (Mājsaimniecības/virtuves pārvaldnieks)"
  echo "=================================================="
  echo -e "${BLUE}Šobrīd ejošie konteineri:${NC}"
  docker ps --format "{{.Names}}"
  echo " "
  echo "-------------------------------------------------"
  read -p "Ievadiet konteinera ciparu lai instalētu/atjauninātu konkrēto konteineri: " container_choice
  clear
  echo "(Pieejamās laika zonas https://docs.diladele.com/docker/timezones.html)"
  echo " "
  read -p "Ievadiet laika zonu ^, kurā atrodas serveris (atstājot tukšu tiks izvēlēts Europe/Riga): " TZ_choice
  clear
  read -p "Ievadiet DOMENA_VARDS ar kuru sasniegsiet serveri (http://DOMENA_VARDS.home -> DOMENA_VARDS ierakstam tikai pašu domēna vārdu bez http:// un .home!): " DOMAIN_NAME

  if [ -z "$TZ_choice" ]; then
      TZ="Europe/Riga"
  else
      TZ="$TZ_choice"
  fi

  echo "Izvēlētā laika zona: $TZ"


if [ $container_choice -eq 1 ]; then #adblock
  ports = "8090"
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
      - "8090:80/tcp"
      - "443:443/tcp"
      - "443:443/udp",
      - "3000:3000/tcp",
      - "853:853/tcp",
      - "784:784/udp",
      - "853:853/udp",
      - "8853:8853/udp",
      - "5443:5443/tcp",
      - "5443:5443/udp"
    volumes:
      - "./DockerFiles/data/AdguardHome/config:/opt/adguardhome/conf"
      - "./DockerFiles/data/AdguardHome/work:/opt/adguardhome/work"
    environment:
      TZ: "$TZ"
EOF
elif [ $container_choice -eq 2 ]; then #jdownloader2
  ports = "5800"
  cat > docker-compose.yml << EOF
version: '3'
services:
  jdownloader-2:
    image: jlesage/jdownloader-2
    ports:
      - "5800:5800"
    volumes:
      - "./DockerFiles/data/jdownloader-2:/config"
      - "./DockerFiles/downloads:/output"
EOF
elif [ $container_choice -eq 3 ]; then #dozzle
  ports = "8001"
  cat > docker-compose.yml << EOF
version: '3'
services:
  dozzle:
    image: amir20/dozzle:latest
    container_name: dozzle
    environment:
      PATH: "/bin"
    ports:
      - "8081:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
EOF
elif [ $container_choice -eq 4 ]; then #photoprism
ports = "2342"
sudo mkdir -p /DockerFiles/data/PhotoPrism/storage
sudo mkdir -p /DockerFiles/data/PhotoPrism/database
sudo mkdir -p /DockerFiles/media
sudo chown -R 1000:1000 /DockerFiles/data/PhotoPrism/storage
sudo chown -R 1000:1000 /DockerFiles/data/PhotoPrism/database
sudo chown -R 1000:1000 /DockerFiles/media

read -p "Ievadiet PhotoPrism administrātora paroli: " PHOTOPRISM_ADMIN_PASSWORD
read -p "Ievadiet PhotoPrism saites pilno adresi (piemēram, http://fotografijas.home) : " PHOTOPRISM_SITE_URL
read -p "Ievadiet vai vēlaties, lai galerijai var piekļūt lokāli bez paroles (y/n): " PHOTOPRISM_PUBLIC_input
if [[ $PHOTOPRISM_PUBLIC_input == "y" ]]; then
    PHOTOPRISM_PUBLIC=true
elif [[ $PHOTOPRISM_PUBLIC_input == "n" ]]; then
    PHOTOPRISM_PUBLIC=false
else
    echo "Nesaprotama ievade. Pieņemam ka nē."
    PHOTOPRISM_PUBLIC=false
fi
read -p "Ievadiet vai vēlaties ieslēgt automātisko cilvēku sejas atpazīšanu (y/n)" PHOTOPRISM_DISABLE_FACES_input
if [[ $PHOTOPRISM_DISABLE_FACES_input == "y" ]]; then
    PHOTOPRISM_DISABLE_FACES=false
elif [[ $PHOTOPRISM_DISABLE_FACES_input == "n" ]]; then
    PHOTOPRISM_DISABLE_FACES=true
else
    echo "Nesaprotama ievade. Pieņemam ka ieslēgsim automātisko sejas atpazīšanu."
    PHOTOPRISM_DISABLE_FACES=false
fi
read -s -p "Ievadiet MySQL datubāzes administratora paroli: " MYSQL_ROOT_PASSWORD
read -s -p "Ievadiet MySQL datubāzes paroli: " MYSQL_PASSWORD
  cat > docker-compose.yml << EOF
version: '3'
services:
  ## App Server (required)
  photoprism:
    ## Use photoprism/photoprism:preview for testing preview builds:
    image: photoprism/photoprism:latest
    depends_on:
      - mariadb
    ## Only enable automatic restarts once your installation is properly
    ## configured as it otherwise may get stuck in a restart loop,
    ## see https://docs.photoprism.org/getting-started/faq/#why-is-photoprism-getting-stuck-in-a-restart-loop
    container_name: photoprism
    restart: unless-stopped
    security_opt:
      - seccomp:unconfined
      - apparmor:unconfined
    ## Run as a specific, non-root user (see https://docs.docker.com/engine/reference/run/#user):
    user: "1000:1000"
    ports:
      - "2342:2342" # HTTP port (host:container)
    environment:
      PHOTOPRISM_ADMIN_PASSWORD: "$PHOTOPRISM_ADMIN_PASSWORD"          # PLEASE CHANGE: Your initial admin password (min 4 characters)
      PHOTOPRISM_SITE_URL: "$PHOTOPRISM_SITE_URL"  # Public server URL incl http:// or https:// and /path, :port is optional
      PHOTOPRISM_ORIGINALS_LIMIT: 5000               # File size limit for originals in MB (increase for high-res video)
      PHOTOPRISM_HTTP_COMPRESSION: "gzip"            # Improves transfer speed and bandwidth utilization (none or gzip)
      PHOTOPRISM_DEBUG: "false"                      # Run in debug mode (shows additional log messages)
      PHOTOPRISM_PUBLIC: "$PHOTOPRISM_PUBLIC" # No authentication required (disables password protection)
      PHOTOPRISM_READONLY: "false"   # Don't modify originals directory (reduced functionality)
      PHOTOPRISM_EXPERIMENTAL: "false"               # Enables experimental features
      PHOTOPRISM_DISABLE_CHOWN: "false"              # Disables storage permission updates on startup
      PHOTOPRISM_DISABLE_WEBDAV: "false"             # Disables built-in WebDAV server
      PHOTOPRISM_DISABLE_SETTINGS: "false"           # Disables Settings in Web UI
      PHOTOPRISM_DISABLE_TENSORFLOW: "false"         # Disables all features depending on TensorFlow
      PHOTOPRISM_DISABLE_FACES: "$PHOTOPRISM_DISABLE_FACES"  # Disables facial recognition
      PHOTOPRISM_DISABLE_CLASSIFICATION: "false"     # Disables image classification
      PHOTOPRISM_DARKTABLE_PRESETS: "false"          # Enables Darktable presets and disables concurrent RAW conversion
      PHOTOPRISM_DETECT_NSFW: "false"                # Flag photos as private that MAY be offensive (requires TensorFlow)
      PHOTOPRISM_UPLOAD_NSFW: "true"                 # Allow uploads that MAY be offensive
      PHOTOPRISM_DATABASE_DRIVER: "mysql"            # Use MariaDB 10.5+ or MySQL 8+ instead of SQLite for improved performance
      PHOTOPRISM_DATABASE_SERVER: "mariadb:3306"     # MariaDB or MySQL database server (hostname:port)
      PHOTOPRISM_DATABASE_NAME: "photoprism"         # MariaDB or MySQL database schema name
      PHOTOPRISM_DATABASE_USER: "photoprism"         # MariaDB or MySQL database user name
      PHOTOPRISM_DATABASE_PASSWORD: "$MYSQL_PASSWORD" # MariaDB or MySQL database user password
      PHOTOPRISM_SITE_TITLE: "PhotoPrism"
      PHOTOPRISM_SITE_CAPTION: "Browse Your Life"
      PHOTOPRISM_SITE_DESCRIPTION: ""
      PHOTOPRISM_SITE_AUTHOR: ""
      HOME: "/photoprism"
    working_dir: "/photoprism"
    volumes:
      ## The *originals* folder contains your original photo and video files (- "[host folder]:/photoprism/originals"):
      - "./DockerFiles/media:/photoprism/originals"
      ## Multiple folders can be made accessible by mounting them as subfolders of /photoprism/originals:
      # - "/mnt/Family:/photoprism/originals/Family"    # [folder 1]:/photoprism/originals/[folder 1]
      # - "/mnt/Friends:/photoprism/originals/Friends"  # [folder 2]:/photoprism/originals/[folder 2]
      ## You may mount an *import* folder from which files can be transferred to *originals* (optional):
      # - "~/Import:/photoprism/import"
      ## Cache, session, thumbnail, and sidecar files will be created in the *storage* folder (never remove):
      - "./DockerFiles/data/PhotoPrism/storage:/photoprism/storage"

  ## Database Server (recommended)
  ## see https://docs.photoprism.org/getting-started/faq/#should-i-use-sqlite-mariadb-or-mysql
  mariadb:
    restart: unless-stopped
    image: mariadb:10.6
    security_opt:
      - seccomp:unconfined
      - apparmor:unconfined
    command: mysqld --transaction-isolation=READ-COMMITTED --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --max-connections=512 --innodb-rollback-on-timeout=OFF --innodb-lock-wait-timeout=120
    volumes:
      - "./DockerFiles/data/PhotoPrism/database:/var/lib/mysql" # never remove
    environment:
      MYSQL_ROOT_PASSWORD: "$MYSQL_ROOT_PASSWORD"
      MYSQL_DATABASE: photoprism
      MYSQL_USER: photoprism
      MYSQL_PASSWORD: "$MYSQL_PASSWORD"
EOF
elif [ $container_choice -eq 5 ]; then #home assistant
  ports = "8999"
  cat > docker-compose.yml << EOF
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    ports:
      - "8999:8123"
    volumes:
      - ./DockerFiles/data/HomeAssistant/config:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
EOF
elif [ $container_choice -eq 6 ]; then #nextcloud
ports = "8083"
read -s -p "Ievadiet MySQL datubāzes administratora paroli: " MYSQL_ROOT_PASSWORD
read -s -p "Ievadiet MySQL datubāzes paroli: " DATABASE_PASSWORD
  cat > docker-compose.yml << EOF
version: "2"
services:
  nextcloud:
    image: linuxserver/nextcloud:latest
    container_name: nextcloud
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$TZ
    volumes:
      - ./DockerFiles/data/Nextcloud/Config:/config
      - ./DockerFiles/data/Nextcloud/Data:/data
    ports:
      - "8083:443"
    restart: unless-stopped
    depends_on:
      - nextcloud_db
  nextcloud_db:
    image: linuxserver/mariadb:latest
    container_name: nextcloud_db
    environment:
      - PUID=1000
      - PGID=1000
      - MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
      - TZ=$TZ
      - MYSQL_DATABASE=nextcloud_db
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=$DATABASE_PASSWORD
    volumes:
      - ./DockerFiles/data/Nextcloud/DB:/config
    restart: unless-stopped
EOF
elif [ $container_choice -eq 7 ]; then #vaultwarden
  ports = "8084"
  cat > docker-compose.yml << EOF
version: '3'
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    ports:
      - "8084:80"
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/data/vaultwarden:/data"
    restart: unless-stopped
EOF
elif [ $container_choice -eq 8 ]; then #heimdall
  ports = "8085"
  cat > docker-compose.yml << EOF
version: '3'
services:
  heimdall:
    image: linuxserver/heimdall:latest
    container_name: heimdall
    ports:
      - "8085:80"
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/data/Heimdall:/config"
    restart: unless-stopped
EOF
elif [ $container_choice -eq 9 ]; then #uptime kuma
  ports = "3001"
  cat > docker-compose.yml << EOF
version: '3'
services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: uptime-kuma
    volumes:
      - ./DockerFiles/data/uptime-kuma:/app/data
    ports:
      - 3001:3001
    restart: unless-stopped
EOF
elif [ $container_choice -eq 10 ]; then #homarr
  ports = "7575"
  cat > docker-compose.yml << EOF
version: '3'
services:
  homarr:
    container_name: homarr
    image: ghcr.io/ajnart/homarr:latest
    restart: unless-stopped
    volumes:
      - ./DockerFiles/data/homarr/configs:/app/data/configs
      - ./DockerFiles/data/homarr/icons:/app/public/icons
    ports:
      - '7575:7575'
    restart: unless-stopped
EOF
elif [ $container_choice -eq 11 ]; then #duplicati
  ports = "8200"
  sudo mkdir -p ./backups
  cat > docker-compose.yml << EOF
version: "3"
services:
  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$TZ
    volumes:
      - ./DockerFiles/data/Duplicati:/config
      - ./backups:/backups
      - ./DockerFiles:/source
    ports:
      - 8200:8200
    restart: unless-stopped
EOF
elif [ $container_choice -eq 12 ]; then #lychee
  ports = "8086"
read -s -p "Ievadiet MySQL datubāzes administratora paroli: " MYSQL_ROOT_PASSWORD
read -s -p "Ievadiet MySQL datubāzes paroli: " MYSQL_PASSWORD
  cat > docker-compose.yml << EOF
version: "3"
services:
  mariadb:
    image: lscr.io/linuxserver/mariadb:latest
    container_name: lychee_mariadb
    restart: always
    volumes:
      - ./DockerFiles/data/mariadb-lychee/data:/config
    environment:
      - MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
      - MYSQL_DATABASE=lychee
      - MYSQL_USER=lychee
      - MYSQL_PASSWORD=$MYSQL_PASSWORD
      - PGID=1000
      - PUID=1000
      - TZ=$TZ
  lychee:
    image: lscr.io/linuxserver/lychee:latest
    container_name: lychee
    restart: always
    depends_on:
      - mariadb
    volumes:
      - ./DockerFiles/data/lychee:/config
      - ./DockerFiles/media:/pictures
    environment:
      - DB_HOST=mariadb
      - DB_USERNAME=lychee
      - DB_PASSWORD=$MYSQL_PASSWORD
      - DB_DATABASE=lychee
      - DB_PORT=3306
      - PGID=1000
      - PUID=1000
      - TZ=$TZ
    ports:
      - 8086:80
EOF
elif [ $container_choice -eq 13 ]; then #speedtest
  ports = "8765"
  cat > docker-compose.yml << EOF
version: '3'
services:
  speedtest:
      container_name: speedtest
      image: henrywhitaker3/speedtest-tracker
      ports:
          - 8765:80
      volumes:
          - ./DockerFiles/data/speedtest-tracker:/config
      environment:
          - TZ=$TZ
          - PGID=1000
          - PUID=1000
          - OOKLA_EULA_GDPR=true
      logging:
          driver: "json-file"
          options:
              max-file: "10"
              max-size: "200k"
      restart: unless-stopped
EOF
elif [ $container_choice -eq 14 ]; then #filebrowser
  ports = "8087"
  cat > docker-compose.yml << EOF
version: '3'
services:
  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: filebrowser
    environment:
      TZ: "$TZ"
    volumes:
      - "./DockerFiles/data/filebrowser/settings.json:/config/settings.json"
      - "./DockerFiles/data/filebrowser/filebrowser.db:/database/filebrowser.db"
      - "./DockerFiles/downloads:/srv"
    ports:
      - "8087:80"
EOF
elif [ $container_choice -eq 15 ]; then #pigallery 2
  ports = "8088"
  cat > docker-compose.yml << EOF
version: '3'
services:
  pigallery2:
    image: bpatrik/pigallery2:latest
    container_name: pigallery2
    environment:
      - NODE_ENV=production # set to 'debug' for full debug logging
    volumes:
      - "./DockerFiles/data/pigallery2/config:/app/data/config"
      - "db-data:/app/data/db"
      - "./DockerFiles/data/pigallery2/images:/app/data/images:ro"
      - "./DockerFiles/data/pigallery2/tmp:/app/data/tmp"
    ports:
      - 8088:80
    restart: always

volumes:
  db-data:
EOF
elif [ $container_choice -eq 16 ]; then #mealie
  ports = "9925"
echo "Pēc noklusējuma lietotājvārds: changeme@email.com un parole: MyPassword"
  cat > docker-compose.yml << EOF
version: "3"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9925:80
    environment:
      PUID: 1000
      PGID: 1000
      TZ: $TZ

      # Default Recipe Settings
      RECIPE_PUBLIC: 'true'
      RECIPE_SHOW_NUTRITION: 'true'
      RECIPE_SHOW_ASSETS: 'true'
      RECIPE_LANDSCAPE_VIEW: 'true'
      RECIPE_DISABLE_COMMENTS: 'false'
      RECIPE_DISABLE_AMOUNT: 'false'

      # Gunicorn
      # WEB_CONCURRENCY: 2
      # WORKERS_PER_CORE: 0.5
      # MAX_WORKERS: 8
    volumes:
      - ./DockerFiles/data/mealie/data/:/app/data
EOF
elif [ $container_choice -eq 17 ]; then #paperless-ngx
  ports = "8000"
  cat > docker-compose.yml << EOF
version: "3"
services:
  paperless-ngx:
    image: lscr.io/linuxserver/paperless-ngx:latest
    container_name: paperless-ngx
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$TZ
    volumes:
      - ./DockerFiles/data/paperless-ngx/config:/config
      - ./DockerFiles/data/paperless-ngx/data:/data
    ports:
      - 8000:8000
    restart: unless-stopped
EOF
elif [ $container_choice -eq 18 ]; then #traefik 
  ports = "8080"
sudo mkdir -p /DockerFiles/data/traefik
sudo touch /DockerFiles/data/traefik/traefik.yml
sudo touch /DockerFiles/data/traefik/config.yml
sudo touch /DockerFiles/data/traefik/acme.json

  cat > docker-compose.yml << EOF
version: "3"
services:
  traefik:
    image: "traefik:v2.10"
    container_name: traefik
    command:
      #- "--log.level=DEBUG"
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - "/DockerFiles/data/traefik:/etc/traefik"
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      - traefik_default

  whoami:
    image: "traefik/whoami"
    container_name: whoami_traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.$DOMAIN_NAME.home`)"
      - "traefik.http.routers.whoami.entrypoints=web"
    networks:
      - traefik_default
EOF
elif [ $container_choice -eq 19 ]; then #grocy
  ports = "9283"
  cat > docker-compose.yml << EOF
version: "3"
services:
  grocy:
    image: lscr.io/linuxserver/grocy:latest
    container_name: grocy
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=$TZ
    volumes:
      - ./DockerFiles/data/grocy:/config
    ports:
      - 9283:80
    networks:
      - traefik_default
    restart: unless-stopped
    labels:
      - traefik.enable=true
      - "traefik.http.services.grocy_svc.loadbalancer.server.port=80"
      - "traefik.http.routers.grocy_http.rule=Host(`grocy.$DOMAIN_NAME.home`)"
      - "traefik.http.routers.grocy_http.entrypoints=web"
      - "traefik.http.routers.grocy_http.service=grocy_svc"
EOF
else
  echo "Nederīga izvēle"
  read -p "Nospiediet ENTER lai turpinātu"
  clear
  ./docker-container-setup.sh
fi
if [ $container_choice -eq 1 ]; then #adblock
  echo "Pirmo reizi uzstādot AdGuard Home nepieciešams interneta pārlūkā pieslēgties: http://$HOSTNAME:3000"
fi
echo "Konteinera piekļuves link: http://$HOSTNAME:$ports"
echo "Ja tiek prasīta parole un lietotājvārds tad parasti tie ir admin/admin. Ieteicams pameklēt programmu dokumentācijā sīkāk"
docker-compose up -d
read -p "Instalēt papildus konteineri? (y/n)" container_install_choice
if [ $container_install_choice = "y" ]; then
clear
./docker-container-setup.sh
elif [ $container_install_choice = "n" ]; then
exit
fi
exit
fi
