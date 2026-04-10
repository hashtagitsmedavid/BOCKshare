#!/bin/bash

# BOCKshare Private Installer for macOS
# Developed by Antigravity for David Tobias Bock

set -e

# Visuals
BRIGHT="\033[1;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BRIGHT}----------------------------------------${RESET}"
echo -e "${BRIGHT}   BOCKshare Private Installer v1.0    ${RESET}"
echo -e "${BRIGHT}----------------------------------------${RESET}"

# 1. Platform Check
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This installer is only for macOS.${RESET}"
    exit 1
fi

# 2. Setup Variables (Adjust these if your repo name changes)
REPO_OWNER="davidtobiasbock"
REPO_NAME="BOCKshare"
ASSET_NAME="BOCKshare.zip"
INSTALL_PATH="/Applications"

# 3. Authentication
echo -e "To access the private repository, please enter your GitHub PAT:"
read -rs GITHUB_TOKEN
echo -e "${GREEN}Token received.${RESET}"

# 4. Fetch Asset ID
echo -e "Fetching latest release information..."
RELEASE_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")

if echo "$RELEASE_JSON" | grep -q "Not Found"; then
    echo -e "${RED}Error: Repository or Release not found. Please check your token and repo name.${RESET}"
    exit 1
fi

ASSET_ID=$(echo "$RELEASE_JSON" | python3 -c "import sys, json; data=json.load(sys.stdin); print([a['id'] for a in data['assets'] if a['name'] == '$ASSET_NAME'][0])")

if [ -z "$ASSET_ID" ]; then
    echo -e "${RED}Error: Asset '$ASSET_NAME' not found in the latest release.${RESET}"
    exit 1
fi

# 5. Download
echo -e "Downloading BOCKshare..."
curl -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/octet-stream" \
     -L -o "/tmp/BOCKshare_dist.zip" \
     "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/assets/$ASSET_ID"

# 6. Installation
echo -e "Installing to $INSTALL_PATH..."
unzip -o -q "/tmp/BOCKshare_dist.zip" -d "$INSTALL_PATH"

# 7. Post-Install (Fix Quarantine)
echo -e "Configuring permissions..."
# Use sudo to ensure we can modify /Applications if needed
sudo xattr -rd com.apple.quarantine "$INSTALL_PATH/BOCKshare.app" 2>/dev/null || true

# 8. Success
rm "/tmp/BOCKshare_dist.zip"
echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}  Installation Successful!              ${RESET}"
echo -e "${GREEN}  You can find BOCKshare in Applications.${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "\n${BRIGHT}Note: The first time you open it, please Right-Click -> Open${RESET}"
