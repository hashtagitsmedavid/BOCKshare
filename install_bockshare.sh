#!/bin/bash
set -e
BRIGHT="\033[1;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BRIGHT}----------------------------------------${RESET}"
echo -e "${BRIGHT}   BOCKshare Public Installer v1.0     ${RESET}"
echo -e "${BRIGHT}----------------------------------------${RESET}"

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This installer is only for macOS.${RESET}"
    exit 1
fi

REPO_URL="https://github.com/hashtagitsmedavid/BOCKshare"
ASSET_URL="https://github.com/hashtagitsmedavid/BOCKshare/raw/main/BOCKshare.zip"
INSTALL_PATH="/Applications"

echo -e "Downloading BOCKshare from $REPO_URL..."
curl -L -o "/tmp/BOCKshare_dist.zip" "$ASSET_URL"

echo -e "Installing to $INSTALL_PATH..."
unzip -o -q "/tmp/BOCKshare_dist.zip" -d "$INSTALL_PATH"

echo -e "Configuring permissions..."
sudo xattr -rd com.apple.quarantine "$INSTALL_PATH/BOCKshare.app" 2>/dev/null || true

rm "/tmp/BOCKshare_dist.zip"
echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}  Installation Successful!              ${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
