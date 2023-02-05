# Ask the user which Docker containers they want to install
options=(pihole nginx mariadb redis)
prompt="Select the Docker containers you want to install (${options[@]}): "
while read -r -p "$prompt" input; do
  containers=("$input")
  break
done

# Install Docker and Docker Compose
sudo apt-get update
sudo apt-get install docker.io docker-compose -y

sudo usermod -aG docker $USER
mkdir ~/DockerFiles/Data

# Loop through the selected containers
for container in "${containers[@]}"; do
  case $container in
    pihole)
      # Download the Docker Compose file for Pi-hole
      sudo wget https://github.com/RSkudra/Fam-Biz_pi/docker_compose_files/raw/master/docker-compose-pihole.yml
      mkdir /DockerFiles/Data/PiHole
      # Start the Pi-hole container using Docker Compose
      sudo docker-compose up -d
      ;;
    nginx)
      # Download the Docker Compose file for Nginx
      sudo wget https://github.com/nginxinc/docker-nginx/raw/main/mainline/alpine/docker-compose.yml

      # Start the Nginx container using Docker Compose
      sudo docker-compose up -d
      ;;
    mariadb)
      # Download the Docker Compose file for MariaDB
      sudo wget https://github.com/mariadb-corporation/mariadb-docker-container/raw/main/docker-compose.yml

      # Start the MariaDB container using Docker Compose
      sudo docker-compose up -d
      ;;
    redis)
      # Download the Docker Compose file for Redis
      sudo wget https://github.com/docker-library/redis/raw/main/docker-compose.yml

      # Start the Redis container using Docker Compose
      sudo docker-compose up -d
      ;;
    *)
      echo "Invalid option: $container"
      ;;
  esac
done
