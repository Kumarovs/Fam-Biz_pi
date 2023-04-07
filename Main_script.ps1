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
ssh -t $username@$server 'if [ -f docker-install.sh ]; then sudo rm docker-install.sh; fi; wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-install.sh && sudo chmod +x docker-install.sh && ./docker-install.sh && bash -i'

