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

SCRIPT_VERSION="v0.7"


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
red='\033[0;31m'

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}


#### Check Sudo ####

if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi


#### Check Curl ####

if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

cancel() {
echo
echo -e "* ${red}Installation Canceled!${reset}"
done=true
exit 1
}

done=false

echo
print_brake 70
echo "* Pterodactyl-AutoThemes Script @ $SCRIPT_VERSION"
echo
echo "* Copyright (C) 2021 - 2021, Ferks-FK."
echo "* https://github.com/Ferks-FK/Pterodactyl-AutoThemes"
echo
echo "* This script is not associated with the official Pterodactyl Project."
print_brake 70
echo

Backup() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/backup.sh)
}

Dracula() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version1.x/Dracula/build.sh)
}

Enola() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version1.x/Enola/build.sh)
}

Twilight() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version1.x/Twilight/build.sh)
}

BlackEndSpace() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/BlackEndSpace/build.sh)
}

BlueBrick() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/BlueBrick/build.sh)
}

LimeStitch() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/LimeStitch/build.sh)
}

MinecraftMadness() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/MinecraftMadness/build.sh)
}

NothingButGraphite() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/NothingButGraphite/build.sh)
}

RedApe() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/RedApe/build.sh)
}

TangoTwist() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version0.7.19/TangoTwist/build.sh)
}

Argon() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/${SCRIPT_VERSION}/themes/version1.x/Argon/build.sh)
}


while [ "$done" == false ]; do
  options=(
    "Restore Panel Backup (Only if you have already installed a theme using this script.)"
    "Install Dracula (Only 1.x)"
    "Install Enola (Only 1.x)"
    "Install Twilight (Only 1.x)"
    "Install Black End Space (Only 0.7.19)"
    "Install Blue Brick (Only 0.7.19)"
    "Install Lime Stitch (Only 0.7.19)"
    "Install Minecraft Madness (Only 0.7.19)"
    "Install Nothing But Graphite (Only 0.7.19)"
    "Install Red Ape (Only 0.7.19)"
    "Install Tango Twist (Only 0.7.19)"
    "Install Argon (Only 0.7.19)"
    
    
    "Cancel Installation"
  )
  
  actions=(
    "Backup"
    "Dracula"
    "Enola"
    "Twilight"
    "BlackEndSpace"
    "BlueBrick"
    "LimeStitch"
    "MinecraftMadness"
    "NothingButGraphite"
    "RedApe"
    "TangoTwist"
    "Argon"
    
    
    "cancel"
  )
  
  echo "* Which theme do you want to install?"
  echo
  
  for i in "${!options[@]}"; do
    echo "[$i] ${options[$i]}"
  done
  
  echo
  echo -n "* Input 0-$((${#actions[@]} - 1)): "
  read -r action
  
  [ -z "$action" ] && error "Input is required" && continue
  
  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done
