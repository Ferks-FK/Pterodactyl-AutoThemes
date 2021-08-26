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
SCRIPT_VERSION="v0.4"
SUPPORT_LINK="https://discord.gg/buDBbSGJmQ"


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

centos)
[ "$OS_VER_MAJOR" == "7" ] && yum install -y zip
[ "$OS_VER_MAJOR" == "8" ] && dnf install -y zip
;;
esac
}


#### Panel Backup ####

backup() {
echo
print_brake 31
echo -e "* ${GREEN}Performing security backup...${reset}"
print_brake 31
cd /var/www/pterodactyl
zip -r PteroBackup-$(date +"%Y-%m-%d").zip public resources
cd
}


#### Donwload Files ####

download_files() {
print_brake 25
echo -e "* ${GREEN}Downloading files...${reset}"
print_brake 25
cd /var/www/pterodactyl
mkdir -p temp
cd temp
curl -sSLo RedApe.tar.gz https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/RedApe/RedApe.tar.gz
tar -xzvf RedApe.tar.gz
cd RedApe
cp -rf -- * /var/www/pterodactyl
cd
cd /var/www/pterodactyl
rm -rf temp
}


bye() {
print_brake 50
echo
echo -e "* ${GREEN}The theme ${YELLOW}Red Ape${GREEN} was successfully installed.${reset}"
echo -e "* ${GREEN}Thank you for using this script.${reset}"
echo -e "* ${GREEN}Support group: $(hyperlink "$SUPPORT_LINK")${reset}"
echo
print_brake 50
}


#### Exec Script ####
check_distro
dependencies
backup
download_files
bye
