#!/bin/bash
# ubuntu-setup.sh
# This script updates Ubuntu, installs Chrome, VS Code, and Terminator,
# and sets Terminator as the default terminal.

echo "🔄 --------------------------------------------------------------------------------------------->>>>>>>> Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "🌐 --------------------------------------------------------------------------------------------->>>>>>>> Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo apt install -y /tmp/google-chrome.deb

echo "📝 --------------------------------------------------------------------------------------------->>>>>>>> Installing Visual Studio Code..."
wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O /tmp/vscode.deb
sudo apt install -y /tmp/vscode.deb

echo "💻 --------------------------------------------------------------------------------------------->>>>>>>> Installing Terminator..."
sudo apt install -y terminator

echo "⚙️ --------------------------------------------------------------------------------------------->>>>>>>> Setting Terminator as the default terminal emulator..."
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/terminator 50
sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator

echo "✅ --------------------------------------------------------------------------------------------->>>>>>>> Setup complete!"
echo "You can now open Terminator from your applications or press Ctrl+Alt+T (if set)."
echo "VS Code and Chrome are also installed and ready to use."

