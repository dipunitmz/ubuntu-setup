#!/bin/bash
# ubuntu-setup.sh
# This script updates Ubuntu, installs Chrome and Terminator,
# and sets Terminator as the default terminal.
#117.6/134.6
echo "🔄 --------------------------------------------------------------------------------------------->>>>>>>> Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "🌐 --------------------------------------------------------------------------------------------->>>>>>>> Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo apt install -y /tmp/google-chrome.deb

echo "💻 --------------------------------------------------------------------------------------------->>>>>>>> Installing Terminator..."
sudo apt install -y terminator

echo "⚙️ --------------------------------------------------------------------------------------------->>>>>>>> Setting Terminator as the default terminal emulator..."
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/terminator 50
sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator

echo "✅ --------------------------------------------------------------------------------------------->>>>>>>> Setup complete!"
echo "You can now open Terminator from your applications or press Ctrl+Alt+T (if set)."

