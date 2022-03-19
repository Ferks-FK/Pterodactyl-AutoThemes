#!/bin/bash

set -e

########################################################
#
#         Pterodactyl-AutoThemes Installation
#
#         Created and maintained by Ferks-FK
#
#            Protected by MIT License
#
########################################################

# Get the latest version before running the script #
get_release() {
curl --silent \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/Ferks-FK/Pterodactyl-AutoThemes/releases/latest |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/'
}

GITHUB_STATUS_URL="https://www.githubstatus.com"
SCRIPT_VERSION="$(get_release)"

# Visual Functions #
print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}

hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}

YELLOW="\033[1;33m"
RESET="\e[0m"
RED='\033[0;31m'

error() {
  echo ""
  echo -e "* ${RED}ERROR${RESET}: $1"
  echo ""
}

# Check Sudo #
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# Check Git #
if [ -z "$SCRIPT_VERSION" ]; then
  error "Could not get the version of the script using GitHub."
  echo "* Please check on the site below if the 'API Requests' are as normal status."
  echo -e "${YELLOW}$(hyperlink "$GITHUB_STATUS_URL")${RESET}"
  exit 1
fi

# Check Curl #
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

cancel() {
echo
echo -e "* ${RED}Installation Canceled!${RESET}"
done=true
exit 1
}

done=false

echo
print_brake 70
echo "* Pterodactyl-AutoThemes Script @ $SCRIPT_VERSION"
echo
echo "* Copyright (C) 2021 - $(date +%Y), Ferks-FK."
echo "* https://github.com/Ferks-FK/Pterodactyl-AutoThemes"
echo
echo "* This script is not associated with the official Pterodactyl Project."
print_brake 70
echo

Backup() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/backup.sh)
}

Dracula() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/Dracula/build.sh)
}

Enola() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/Enola/build.sh)
}

Twilight() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/Twilight/build.sh)
}

ZingTheme() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/ZingTheme/build.sh)
}

FlancoTheme() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/FlancoTheme/build.sh)
}

BackgroundVideo() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/BackgroundVideo/build.sh)
}

AnimatedGraphics() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/AnimatedGraphics/build.sh)
}


while [ "$done" == false ]; do
  options=(
    "Restore Panel Backup (Only if you have an installation problem.)"
    "Install Dracula (Only 1.6.6 and 1.7.0)"
    "Install Enola (Only 1.6.6 and 1.7.0)"
    "Install Twilight (Only 1.6.6 and 1.7.0)"
    "Install Zing Theme (Only 1.6.6 and 1.7.0)"
    "Install Flanco Theme (Only 1.6.6 and 1.7.0)"
    "Install Background Video (Only 1.6.6 and 1.7.0)"
    "Install Animated Graphics (Only 1.6.6 and 1.7.0)"
    
    
    "Cancel Installation"
  )
  
  actions=(
    "Backup"
    "Dracula"
    "Enola"
    "Twilight"
    "ZingTheme"
    "FlancoTheme"
    "BackgroundVideo"
    "AnimatedGraphics"
    
    
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
