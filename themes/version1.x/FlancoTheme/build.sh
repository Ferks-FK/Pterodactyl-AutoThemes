#!/bin/bash
# shellcheck source=/dev/null

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

# Fixed Variables #
SCRIPT_VERSION="$(get_release)"
SUPPORT_LINK="https://discord.gg/buDBbSGJmQ"

# Update Variables #
update_variables() {
CONFIG_FILE="$PTERO/config/app.php"
PANEL_VERSION="$(grep "'version'" "$CONFIG_FILE" | cut -c18-25 | sed "s/[',]//g")"
}

# Visual Functions #
print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
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

print() {
  echo ""
  echo -e "* ${GREEN}$1${RESET}"
  echo ""
}

hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
RED='\033[0;31m'
RESET="\e[0m"

# OS check #
check_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$(echo "$ID" | awk '{print tolower($0)}')
    OS_VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si | awk '{print tolower($0)}')
    OS_VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$(echo "$DISTRIB_ID" | awk '{print tolower($0)}')
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

  OS=$(echo "$OS" | awk '{print tolower($0)}')
  OS_VER_MAJOR=$(echo "$OS_VER" | cut -d. -f1)
}

# Find where pterodactyl is installed #
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

# Verify Compatibility #
compatibility() {
print "Checking if the addon is compatible with your panel..."

sleep 2
if [ "$PANEL_VERSION" == "1.6.6" ] || [ "$PANEL_VERSION" == "1.7.0" ]; then
    print "Compatible Version!"
  else
    print_error "Incompatible Version!"
    exit 1
fi
}

# Install Dependencies #
dependencies() {
print "Installing dependencies..."

if node -v &>/dev/null; then
    print "The dependencies are already installed, skipping this step..."
  else
    case "$OS" in
      debian | ubuntu)
        curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && apt-get install -y nodejs
      ;;
      centos)
        [ "$OS_VER_MAJOR" == "7" ] && curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo yum install -y nodejs yarn
        [ "$OS_VER_MAJOR" == "8" ] && curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo dnf install -y nodejs
      ;;
    esac
fi
}

# Panel Backup #
backup() {
print "Performing security backup..."

if [ -d "$PTERO/PanelBackup[Auto-Themes]" ]; then
    print "There is already a backup, skipping step..."
  else
    cd $PTERO
    if [ -d "$PTERO/node_modules" ]; then
        tar -czvf "PanelBackup[Auto-Themes].tar.gz" --exclude "node_modules" -- * .env
        mkdir -p "$PTERO/PanelBackup[Auto-Themes]"
        mv "$PTERO/PanelBackup[Auto-Themes].tar.gz" "$PTERO/PanelBackup[Auto-Themes]"
      else
        tar -czvf "PanelBackup[Auto-Themes].tar.gz" -- * .env
        mkdir -p "$PTERO/PanelBackup[Auto-Themes]"
        mv "$PTERO/PanelBackup[Auto-Themes].tar.gz" "$PTERO/PanelBackup[Auto-Themes]"
    fi
fi
}

# Download Files #
download_files() {
print "Downloading files..."

mkdir -p $PTERO/temp
curl -sSLo $PTERO/temp/FlancoTheme.tar.gz https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/themes/version1.x/FlancoTheme/FlancoTheme.tar.gz
tar -xzvf $PTERO/temp/FlancoTheme.tar.gz -C $PTERO/temp
cp -rf -- $PTERO/temp/FlancoTheme/* $PTERO
rm -rf $PTERO/temp
}

# Panel Production #
production() {
print "Producing panel..."
print_warning "This process takes a few minutes, please do not cancel it."

if [ -d "$PTERO/node_modules" ]; then
    yarn --cwd $PTERO add @emotion/react
    yarn --cwd $PTERO build:production
  else
    npm i -g yarn
    yarn --cwd $PTERO install
    yarn --cwd $PTERO add @emotion/react
    yarn --cwd $PTERO build:production
fi
}

bye() {
print_brake 50
echo
echo -e "${GREEN}* The theme ${YELLOW}Flanco Theme${GREEN} was successfully installed."
echo -e "* A security backup of your panel has been created."
echo -e "* Thank you for using this script."
echo -e "* Support group: ${YELLOW}$(hyperlink "$SUPPORT_LINK")${RESET}"
echo
print_brake 50
}

# Exec Script #
check_distro
find_pterodactyl
if [ "$PTERO_INSTALL" == true ]; then
    print "Installation of the panel found, continuing the installation..."

    compatibility
    dependencies
    backup
    download_files
    production
    bye
  elif [ "$PTERO_INSTALL" == false ]; then
    print_warning "The installation of your panel could not be located."
    echo -e "* ${GREEN}EXAMPLE${RESET}: ${YELLOW}/var/www/mypanel${RESET}"
    echo -ne "* Enter the pterodactyl installation directory manually: "
    read -r MANUAL_DIR
    if [ -d "$MANUAL_DIR" ]; then
        print "Directory has been found!"
        PTERO="$MANUAL_DIR"
        update_variables
        compatibility
        dependencies
        backup
        download_files
        production
        bye
      else
        print_error "The directory you entered does not exist."
        find_pterodactyl
    fi
fi

