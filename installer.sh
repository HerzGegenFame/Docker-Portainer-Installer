#!/bin/bash
lightblue='\033[1;34m'
nc='\033[0m' # No Color
cyan=' \033[0;36m'
red='\033[0;31m'
green='\033[0;32m'
lightgreen='\033[1;32m'

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
port=9000
update=1

echo -e " ${lightblue} _____             _              ${nc}          ";
echo -e " ${lightblue}|  __ \           | |             ${nc}  ___     ";
echo -e " ${lightblue}| |  | | ___   ___| | _____ _ __  ${nc} ( _ )    ";
echo -e " ${lightblue}| |  | |/ _ \ / __| |/ / _ \ '__| ${nc} / _ \/\  ";
echo -e " ${lightblue}| |__| | (_) | (__|   <  __/ |    ${nc}| (_>  <  ";
echo -e " ${lightblue}|_____/ \___/ \___|_|\_\___|_|    ${nc} \___/\/  ";
echo -e " ${lightblue}|  __ \         | |      (_)                ";
echo -e " ${lightblue}| |__) |__  _ __| |_ __ _ _ _ __   ___ _ __ ";
echo -e " ${lightblue}|  ___/ _ \| '__| __/ _\` | | '_ \ / _ \ '__|";
echo -e " ${lightblue}| |  | (_) | |  | || (_| | | | | |  __/ |   ";
echo -e " ${lightblue}|_|___\___/|_|   \__\__,_|_|_| |_|\___|_|   ";
echo -e " ${nc}|_   _|         | |      | | |              ";
echo -e "   | |  _ __  ___| |_ __ _| | | ___ _ __     ";
echo -e "   | | | '_ \/ __| __/ _\` | | |/ _ \ '__|    ";
echo -e "  _| |_| | | \__ \ || (_| | | |  __/ |       ";
echo -e " |_____|_| |_|___/\__\__,_|_|_|\___|_|       ";
echo -e "                                             ";
echo -e "                             ${red}by HerzGegenFame";

echo ""
echo ""
echo ""
echo ""

echo -e "Update and Upgrade Packages? "
echo -e "${lightgreen}1 = yes "
echo -e "2 = no${nc}"
echo -e "Default = yes"
read update

if (( update = 1 )); 
then

    $SUDO su - root -c "apt update -y;apt upgrade -y;"
    echo -e "Should Docker be Installed?"
    echo -e "${lightgreen}1 = yes "
    echo -e "2 = no${nc}
    echo -e "Default = yes"
    read docker

    if (( docker = 1 ))
    then
        $SUDO su - root -c "curl -fsSL https://get.docker.com -o get-docker.sh"
        $SUDO su - root -c "sh get-docker.sh"
        $SUDO su - root -c "rm get-docker.sh"
        $SUDO su - root -c "apt install docker-compose -y"
    fi

    echo -e "Should Portainer be Installed?"
    echo -e "${lightgreen}1 = yes "
    echo -e "2 = no${nc}
    echo -e "Default = yes"
    read portainer
    if (( portainer = 1 ))
    then
        echo -e "Should a custom Port be used for the Webinterface?"
        echo -e "${lightgreen}1 = yes "
        echo -e "2 = no${nc}
        echo -e "Default = yes"
        echo "Default = 9000"
        read custom
        if (( $custom = 1 )); then
            echo -e "What Port would you like to use for the Webinterface"
            read port
        fi
        $SUDO su - root -c "docker volume create portainer_data"
        $SUDO su - root -c "docker run -d -p 8000:8000 -p $port:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce"
    else
        echo "Portainer will not not be installed"
    fi
    echo "Done"
else
    echo -e "${red}Packages have to be Updated and Upgraded"
fi
