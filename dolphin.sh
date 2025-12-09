#!/bin/bash

# Function to detect package manager and install Dolphin
install_dolphin() {
    if command -v apt &> /dev/null; then
        echo "Detected Debian/Ubuntu-based system. Installing Dolphin using apt..."
        # Add the 'universe' repository for older Ubuntu versions if needed
        sudo add-apt-repository universe -y
        sudo apt update
        sudo apt install dolphin -y
    elif command -v dnf &> /dev/null; then
        echo "Detected Fedora/RHEL-based system. Installing Dolphin using dnf..."
        sudo dnf install dolphin -y
    elif command -v yum &> /dev/null; then
        echo "Detected RHEL/CentOS-based system. Installing Dolphin using yum..."
        sudo yum install dolphin -y
    else
        echo "Unsupported package manager. Please install Dolphin manually."
        exit 1
    fi
}

# Function to set Dolphin as the default file manager using xdg-mime
set_default_dolphin() {
    echo "Setting Dolphin as the default file manager..."
    # Set Dolphin as the default for directories (inode/directory)
    xdg-mime default org.kde.dolphin.desktop inode/directory
    # Set Dolphin as the default for saved searches, common in GNOME
    xdg-mime default org.kde.dolphin.desktop application/x-gnome-saved-search

    # Ensure the settings are reflected in the user's mimeapps.list file
    echo "inode/directory=org.kde.dolphin.desktop" >> "$HOME/.local/share/applications/mimeapps.list"
    echo "application/x-gnome-saved-search=org.kde.dolphin.desktop" >> "$HOME/.local/share/applications/mimeapps.list"
    sort -u "$HOME/.local/share/applications/mimeapps.list" -o "$HOME/.local/share/applications/mimeapps.list"

    echo "Dolphin should now be the default file manager."
    echo "You may need to log out and log back in for changes to take full effect across all applications."
}

# Main execution
echo "Starting Dolphin installation and setup script..."
install_dolphin
if [ $? -eq 0 ]; then
    set_default_dolphin
else
    echo "Dolphin installation failed, skipping default setup."
fi
echo "Script finished."
