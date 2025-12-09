#!/bin/bash

# Remove Brave Browser
sudo apt remove --purge -y brave-browser

# Clean up unnecessary packages
sudo apt autoremove --purge -y

# Remove Brave's APT repository and GPG keyring
sudo rm -f /etc/apt/sources.list.d/brave-browser-release.sources
sudo rm -f /usr/share/keyrings/brave-browser-archive-keyring.gpg

# Update APT package lists
sudo apt update

# Optional: Verify Brave Browser removal
which brave-browser &> /dev/null
if [ $? -eq 0 ]; then
    echo "Brave browser is still installed."
else
    echo "Brave browser has been successfully uninstalled."
fi
