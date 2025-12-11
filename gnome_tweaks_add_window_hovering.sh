#!/bin/bash

# Function to install gnome-tweaks based on distribution
install_gnome_tweaks() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop|mint)
                echo "Detected Debian/Ubuntu-based system. Installing gnome-tweaks..."
                sudo apt update && sudo apt install -y gnome-tweaks
                ;;
            fedora|centos|rhel)
                echo "Detected Fedora-based system. Installing gnome-tweaks..."
                sudo dnf install -y gnome-tweaks
                ;;
            arch|manjaro)
                echo "Detected Arch-based system. Installing gnome-tweaks..."
                sudo pacman -Sy --noconfirm gnome-tweaks
                ;;
            *)
                echo "Unsupported distribution for automatic installation. Please install gnome-tweaks manually."
                exit 1
                ;;
        esac
    else
        echo "Could not detect OS. Please install gnome-tweaks manually."
        exit 1
    fi
}

# Function to enable "focus on hover" (sloppy focus mode)
enable_hover_focus() {
    echo "Enabling 'Focus on Hover' (sloppy focus mode)..."
    gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
    
    # Optional: Automatically raise the window after a short delay
    echo "Setting windows to raise automatically when focused..."
    gsettings set org.gnome.desktop.wm.preferences auto-raise true
    gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 300 # Delay in milliseconds

    echo "Settings applied. You may need to log out and log back in for all changes to take full effect."
}

# Main execution
echo "Starting GNOME Tweaks installation and configuration script."
install_gnome_tweaks
enable_hover_focus
echo "Script finished."
