$isInstall = Read-Host "Vai ir uzinstalēts Docker? (y/n)"
# Prompt the user for the username and IP address of the Debian server
$isDefault = Read-Host "Vai servera lietotājvārds ir (pi) un servera vārds ir (raspberrypi)? (y/n)"
if ($isDefault -eq "n") {
    $username = Read-Host "Ierakstiet Debian servera lietotājvardu: "
    $server = Read-Host "Ierakstiet Debian servera vārdu vai IP adresi: "
}
else {
        $username = "pi"
        $server = "raspberrypi"
}

# Connect to the Debian server and download the Debian script
if($isInstall -eq "y") {
    ssh -t $username@$server 'if [ -f docker-container-setup.sh ]; then sudo rm docker-container-setup.sh; fi; wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-container-setup.sh && sudo chmod +x docker-container-setup.sh && sudo ./docker-container-setup.sh && bash -i'
}
else {
ssh -t $username@$server 'if [ -f docker-install.sh ]; then sudo rm docker-install.sh; fi; wget https://raw.githubusercontent.com/RJSkudra/Fam-Biz_pi/main/docker-install.sh && sudo chmod +x docker-install.sh && ./docker-install.sh && bash -i'
}
