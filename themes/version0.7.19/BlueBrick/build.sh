#!/bin/bash

set -e

########################################################
# 
#         Pterodactyl-AutoThemes Installation
#
#         Created and maintained by Ferks-FK
#
#            Protected by GPL 3.0 License
#
########################################################

#### Variables ####
SCRIPT_VERSION="v0.8.2"


print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}


hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}


#### Colors ####

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
reset="\e[0m"


#### OS check ####

check_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$(echo "$ID")
    OS_VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    OS_VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$(echo "$DISTRIB_ID")
    OS_VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    OS="debian"
    OS_VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
    OS="SuSE"
    OS_VER="?"
  elif [ -f /etc/redhat-release ]; then
    OS="Red Hat/CentOS"
    OS_VER="?"
  else
    OS=$(uname -s)
    OS_VER=$(uname -r)
  fi

  OS=$(echo "$OS")
  OS_VER_MAJOR=$(echo "$OS_VER" | cut -d. -f1)
}


#### Install Dependencies ####

dependencies() {
echo
print_brake 30
echo -e "* ${GREEN}Installing dependencies...${reset}"
print_brake 30
echo
case "$OS" in
debian | ubuntu)
apt-get install -y zip
;;
esac

if [ "$OS_VER_MAJOR" == "7" ]; then
sudo yum install -y zip
fi

if [ "$OS_VER_MAJOR" == "8" ]; then
sudo dnf install -y zip
fi
}


#### Panel Backup ####

backup() {
echo
print_brake 32
echo -e "* ${GREEN}Performing security backup...${reset}"
print_brake 32
if [ -f "/var/www/pterodactyl/PanelBackup/PanelBackup.zip" ]; then
echo
print_brake 45
echo -e "* ${GREEN}There is already a backup, skipping step...${reset}"
print_brake 45
echo
else
cd /var/www/pterodactyl
mkdir -p PanelBackup
zip -r PanelBackup.zip app config public resources routes storage database .env
mv PanelBackup.zip PanelBackup
fi
}


#### Donwload Files ####

download_files() {
print_brake 25
echo -e "* ${GREEN}Downloading files...${reset}"
print_brake 25
cd /var/www/pterodactyl
mkdir -p temp
cd temp
curl -sSLo BlueBrick.tar.gz https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/BlueBrick/BlueBrick.tar.gz
tar -xzvf BlueBrick.tar.gz
cd BlueBrick
cp -rf -- * /var/www/pterodactyl
cd
cd /var/www/pterodactyl
rm -rf temp
}


bye() {
print_brake 50
echo
echo -e "* ${GREEN}The theme ${YELLOW}Blue Brick${GREEN} was successfully installed."
echo -e "* A security backup of your panel has been created."
echo -e "* Thank you for using this script."
echo
print_brake 50
}

#### Exec Script ####
check_distro
dependencies
backup
download_files
bye
