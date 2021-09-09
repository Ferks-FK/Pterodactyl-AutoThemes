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
red='\033[0;31m'


#### Removal of theme files ####

DET() {
if [ -f "/var/www/pterodactyl/resources/scripts/user.css" ]; then
cd /var/www/pterodactyl/resources/scripts
rm -r user.css
cd
else
echo
fi
if [ -f "/var/www/pterodactyl/public/themes/pterodactyl/css/admin.css" ]; then
cd /var/www/pterodactyl/public/themes/pterodactyl/css
rm -r admin.css
cd
else
echo
fi
}

zing() {
if [ -f "/var/www/pterodactyl/resources/scripts/components/SidePanel.tsx" ]; then
cd /var/www/pterodactyl/resources/scripts/components
rm -r SidePanel.tsx
cd
else
echo
fi
if [ -f "/var/www/pterodactyl/resources/scripts/components/server/files/FileViewer.tsx" ]; then
cd /var/www/pterodactyl/resources/scripts/components/server/files
rm -r FileViewer.tsx
cd
else
echo
fi
}

argon() {
if [ -d "/var/www/pterodactyl/public/themes/argon" ]; then
cd /var/www/pterodactyl/public/themes
rm -R argon
else
echo
fi
if [ -d "/var/www/pterodactyl/resources/themes/argon" ]; then
cd /var/www/pterodactyl/resources/themes
rm -R argon
else
echo
fi
}


#### Restore Backup ####

restore() {
echo
print_brake 35
echo -e "* ${GREEN}Checking for a backup...${reset}"
print_brake 35
echo
if [ -f "/var/www/pterodactyl/PanelBackup/PanelBackup.zip" ]; then
cd /var/www/pterodactyl/PanelBackup
unzip PanelBackup.zip
rm -R PanelBackup.zip
cp -rf app config database public resources routes storage .env /var/www/pterodactyl
cd
else
print_brake 45
echo -e "* ${red}There was no backup to restore, Aborting...${reset}"
print_brake 45
echo
exit 1
fi
if [ -f "/var/www/pterodactyl/PanelBackup/tailwind.config.js" ]; then
cd /var/www/pterodactyl/PanelBackup
cp -rf tailwind.config.js /var/www/pterodactyl
cd ..
rm -rf PanelBackup
else
echo
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
DET
zing
argon
restore
bye
