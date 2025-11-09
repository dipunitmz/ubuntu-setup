#!/usr/bin/env bash
set -e

echo "🛠 Installing required packages..."
sudo apt update -qq
sudo apt install -y gnome-screenshot xclip libnotify-bin gsettings-desktop-schemas

echo "📸 Setting up custom screenshot shortcuts..."

# Commands
CMD_SAVE_COPY='bash -c "dir=\"$HOME/Pictures/Screenshots\"; mkdir -p \"$dir\"; file=\"$dir/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png\"; gnome-screenshot -a -f \"$file\" && xclip -selection clipboard -t image/png -i \"$file\" && sleep 0.3 && notify-send \"Screenshot saved & copied ✅\""' 
CMD_CLIP_ONLY='bash -c "file=$(mktemp --suffix=.png); gnome-screenshot -a -f \"$file\" && xclip -selection clipboard -t image/png -i \"$file\"; rm \"$file\""' 

# Shortcut names and keys
NAME1="Screenshot Save+Copy"
NAME2="Screenshot Clipboard Only"
KEY1="<Super><Shift>s"
KEY2="<Ctrl><Alt>s"

# Define paths
PATH1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
PATH2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"

# Register custom keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$PATH1', '$PATH2']"

# Create first shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 name "$NAME1"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 command "$CMD_SAVE_COPY"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 binding "$KEY1"

# Create second shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 name "$NAME2"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 command "$CMD_CLIP_ONLY"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 binding "$KEY2"

echo
echo "✅ Shortcuts added successfully!"
echo "   • Win + Shift + S → Save + copy + notification (0.3 s delay)"
echo "   • Ctrl + Alt + S → Copy only (no save, no notify)"

