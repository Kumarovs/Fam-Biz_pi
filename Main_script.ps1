# Prompt the user to select from a list of pre-determined Docker containers
$options = @("pihole", "nginx", "mariadb", "redis")
$selectedOption = Read-Host "Select the Docker container you want to install ($($options -join ', '))"

# Prompt the user for the username and IP address of the Debian server
$username = Read-Host "Enter the username for the Debian server"
$server = Read-Host "Enter the IP address of the Debian server"

# Connect to the Debian server using SSH
ssh $username@$server

# Install Docker on the server if it's not already installed
sudo apt-get update
sudo apt-get install docker.io -y

# Check if the selected container is in the list of pre-determined options
if ($options -contains $selectedOption) {
    switch ($selectedOption) {
        "pihole" {
            sudo docker run -d --name pihole -p 53:53/tcp -p 53:53/udp -p 80:80 pihole/pihole
        }
        "nginx" {
            sudo docker run --name nginx -p 80:80 -d nginx
        }
        "mariadb" {
            sudo docker run --name mariadb -e MYSQL_ROOT_PASSWORD=secret -d mariadb
        }
        "redis" {
            sudo docker run --name redis -d redis
        }
    }
    Write-Host "The selected Docker container ($selectedOption) has been installed."
}
else {
    Write-Host "Invalid option selected. Please choose one of the following: ($($options -join ', '))"
}