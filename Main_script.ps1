# Prompt the user to select from a list of pre-determined Docker containers
#$options = @("pihole - DNS server", "nginx - Website host", "mariadb - Database")
#$selectedOption = Read-Host "Select the Docker container you want to install ($($options -join ', '))"

# Prompt the user for the username and IP address of the Debian server
$isDefault = Read-Host "Is the install changed? (y/n)"
if ($isDefault -eq "y") {
    $username = Read-Host "Enter the username for the Debian server"
    $server = Read-Host "Enter the IP address of the Debian server"
}
else {
        $username = "pi"
        $server = "fampi"
}

# Connect to the Debian server and download the Debian script
ssh -t $username@$server 'sudo rm docker-install.sh && wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-install.sh && sudo chmod +x docker-install.sh && ./docker-install.sh && bash -i'
