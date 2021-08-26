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
PTERO_VERSION="v1.5.1"
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
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && apt-get install -y nodejs
;;

centos)
[ "$OS_VER_MAJOR" == "7" ] && curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo yum install -y nodejs yarn
[ "$OS_VER_MAJOR" == "8" ] && curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo dnf install -y nodejs yarn
;;
esac
}


#### Donwload Files ####
print_brake 25
echo -e "* ${GREEN}Downloading files...${reset}"
print_brake 25
download_files() {
cd /var/www/pterodactyl/resources/scripts
rm -R index.tsx user.css
curl -o index.tsx https://raw.githubusercontent.com/pterodactyl/panel/${PTERO_VERSION}/resources/scripts/index.tsx
cd
cd /var/www/pterodactyl/resources/views/layouts
rm -R admin.blade.php
curl -o admin.blade.php https://raw.githubusercontent.com/pterodactyl/panel/${PTERO_VERSION}/resources/views/layouts/admin.blade.php
}

#### Panel Production ####

production() {
DIR=/var/www/pterodactyl

if [ -d "$DIR" ]; then
echo
print_brake 25
echo -e "* ${GREEN}Producing panel...${reset}"
print_brake 25
npm i -g yarn
cd /var/www/pterodactyl
yarn
yarn build:production
fi
}


bye() {
print_brake 50
echo
echo -e "* ${GREEN}The theme ${YELLOW}Default${GREEN} was successfully installed.${reset}"
echo -e "* ${GREEN}Thank you for using this script.${reset}"
echo -e "* ${GREEN}Support group: $(hyperlink "$SUPPORT_LINK")${reset}"
echo
print_brake 50
}


#### Exec Script ####
check_distro
dependencies
download_files
production
bye
