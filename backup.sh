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
INFORMATIONS="/var/log/Pterodactyl-AutoThemes-informations"
DET="$PTERO/public/themes/pterodactyl/css/admin.css"
ZING="$PTERO/resources/scripts/components/SidePanel.tsx"
if [ -f "${INFORMATIONS}/background.txt" ]; then BACKGROUND="$(cat "${INFORMATIONS}/background.txt")"; fi
}

print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}

print() {
  echo ""
  echo -e "* ${GREEN}$1${RESET}"
  echo ""
}

print_warning() {
  echo ""
  echo -e "* ${YELLOW}WARNING${RESET}: $1"
  echo ""
}

print_error() {
  echo ""
  echo -e "* ${RED}ERROR${RESET}: $1"
  echo ""
}

hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
RESET="\e[0m"
RED='\033[0;31m'

#### Find where pterodactyl is installed ####

find_pterodactyl() {
print "Looking for your pterodactyl installation..."

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
  rm -rf "$DET"
  rm -rf "$PTERO/resources/scripts/user.css"
fi
#### THEMES DRACULA, ENOLA AND TWILIGHT ####

#### THEME ZINGTHEME ####
if [ -f "$ZING" ]; then
  rm -rf "$ZING"
  rm -rf "$PTERO/resources/scripts/components/server/files/FileViewer.tsx"
fi
#### THEME ZINGTHEME ####

#### BACKGROUND VIDEO ####
if [ -f "$PTERO/public/$BACKGROUND" ]; then
  rm -rf "$PTERO/public/$BACKGROUND"
  rm -rf "$PTERO/resources/scripts/user.css"
  rm -rf "$INFORMATIONS"
fi
#### BACKGROUND VIDEO ####
}

#### Restore Backup ####

restore() {
print "Checking for a backup..."

if [ -d "$PTERO/PanelBackup[Auto-Themes]" ]; then
    cd "$PTERO/PanelBackup[Auto-Themes]"
    tar -xzvf "$PTERO/PanelBackup[Auto-Themes]/PanelBackup[Auto-Themes].tar.gz"
    rm -rf "$PTERO/PanelBackup[Auto-Themes]/PanelBackup[Auto-Themes].tar.gz"
    cp -r -- * .env "$PTERO"
    rm -rf "$PTERO/PanelBackup[Auto-Themes]"
  else
    print_error "There was no backup to restore, Aborting..."
    exit 1
fi
}

bye() {
print_brake 50
echo
echo -e "${GREEN}* Backup restored successfully!"
echo -e "* Thank you for using this script."
echo -e "* Support group: ${YELLOW}$(hyperlink "$SUPPORT_LINK")${RESET}"
echo
print_brake 50
}

#### Exec Script ####
find_pterodactyl
if [ "$PTERO_INSTALL" == true ]; then
    print "Installation of the panel found, continuing the backup..."
    delete_files
    restore
    bye
  elif [ "$PTERO_INSTALL" == false ]; then
    print_warning "The installation of your panel could not be located."
    echo -e "* ${GREEN}EXAMPLE${RESET}: ${YELLOW}/var/www/mypanel${RESET}"
    echo -ne "* Enter the pterodactyl installation directory manually: "
    read -r MANUAL_DIR
    if [ -d "$MANUAL_DIR" ]; then
        print "Directory has been found!"
        PTERO="$MANUAL_DIR"
        echo "$MANUAL_DIR" >> "$INFORMATIONS/custom_directory.txt"
        update_variables
        delete_files
        restore
        bye
      else
        print_error "The directory you entered does not exist."
        find_pterodactyl
    fi
fi
