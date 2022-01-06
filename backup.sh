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

#### Fixed Variables ####

SUPPORT_LINK="https://discord.gg/buDBbSGJmQ"

#### Update Variables ####

update_variables() {
DET="$PTERO/resources/scripts/user.css"
ZING="$PTERO/resources/scripts/components/SidePanel.tsx"
}


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

#### Find where pterodactyl is installed ####

find_pterodactyl() {
echo
print_brake 47
echo -e "* ${GREEN}Looking for your pterodactyl installation...${reset}"
print_brake 47
echo
sleep 2
if [ -d "/var/www/pterodactyl" ]; then
    PTERO_INSTALL=true
    PTERO="/var/www/pterodactyl"
  elif [ -d "/var/www/panel" ]; then
    PTERO_INSTALL=true
    PTERO="/var/www/panel"
  elif [ -d "/var/www/ptero" ]; then
    PTERO_INSTALL=true
    PTERO="/var/www/ptero"
  else
    PTERO_INSTALL=false
fi
# Update the variables after detection of the pterodactyl installation #
update_variables
}


#### Deletes all files installed by the script ####

delete_files() {
#### THEMES DRACULA, ENOLA AND TWILIGHT ####
if [ -f "$DET" ]; then
  rm -r "$DET"
  rm -r "$PTERO/public/themes/pterodactyl/css/admin.css"
fi
#### THEMES DRACULA, ENOLA AND TWILIGHT ####

#### THEME ZINGTHEME ####
if [ -f "$ZING" ]; then
  rm -r "$ZING"
  rm -r "$PTERO/resources/scripts/components/server/files/FileViewer.tsx"
fi
#### THEME ZINGTHEME ####
}


#### Restore Backup ####

restore() {
echo
print_brake 35
echo -e "* ${GREEN}Checking for a backup...${reset}"
print_brake 35
echo
if [ -d "$PTERO/PanelBackup[Auto-Themes]" ]; then
    cd "$PTERO/PanelBackup[Auto-Themes]"
    tar -xzvf "PanelBackup[Auto-Themes].tar.gz"
    rm -R "PanelBackup[Auto-Themes].tar.gz"
    cp -r -- * .env "$PTERO"
    rm -r "$PTERO/PanelBackup[Auto-Themes]"
  else
    print_brake 45
    echo -e "* ${red}There was no backup to restore, Aborting...${reset}"
    print_brake 45
    echo
    exit 1
fi
}


bye() {
print_brake 50
echo
echo -e "${GREEN}* Backup restored successfully!"
echo -e "* Thank you for using this script."
echo -e "* Support group: ${YELLOW}$(hyperlink "$SUPPORT_LINK")${reset}"
echo
print_brake 50
}


#### Exec Script ####
find_pterodactyl
if [ "$PTERO_INSTALL" == true ]; then
    echo
    print_brake 60
    echo -e "* ${GREEN}Installation of the panel found, continuing the backup...${reset}"
    print_brake 60
    echo
    delete_files
    restore
    bye
  elif [ "$PTERO_INSTALL" == false ]; then
    echo
    print_brake 66
    echo -e "* ${red}The installation of your panel could not be located, aborting...${reset}"
    print_brake 66
    echo
    exit 1
fi
