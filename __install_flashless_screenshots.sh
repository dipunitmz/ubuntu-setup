#!/usr/bin/env bash
set -e

echo "🛠 Installing required packages..."
sudo apt update -qq
sudo apt install -y gnome-screenshot xclip libnotify-bin gsettings-desktop-schemas

echo "📸 Disabling GNOME flash animation..."
gsettings set org.gnome.desktop.interface enable-animations false

echo "📸 Creating screenshot scripts..."
SCRIPT_DIR="$HOME/.local/bin"
mkdir -p "$SCRIPT_DIR"

# 1️⃣ Save + Copy + Notify
SAVE_COPY_SCRIPT="$SCRIPT_DIR/flashless_save_copy.sh"
cat << 'EOF' > "$SAVE_COPY_SCRIPT"
#!/usr/bin/env bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%F_%H-%M-%S).png"

gnome-screenshot -a -f "$FILE"

cat "$FILE" | xclip -selection clipboard -t image/png

notify-send "Screenshot saved & copied" "$FILE"
EOF
chmod +x "$SAVE_COPY_SCRIPT"

# 2️⃣ Copy Only (no save)
COPY_ONLY_SCRIPT="$SCRIPT_DIR/flashless_copy_only.sh"
cat << 'EOF' > "$COPY_ONLY_SCRIPT"
#!/usr/bin/env bash
FILE=$(mktemp --suffix=.png)

gnome-screenshot -a -f "$FILE"

cat "$FILE" | xclip -selection clipboard -t image/png

rm "$FILE"
EOF
chmod +x "$COPY_ONLY_SCRIPT"

echo "⌨️ Setting up GNOME shortcuts..."

NAME1="Flashless Save+Copy"
NAME2="Flashless CopyOnly"

KEY1="<Super><Shift>s"
KEY2="<Ctrl><Alt>s"

PATH1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-flashless0/"
PATH2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-flashless1/"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['$PATH1', '$PATH2']"

# Shortcut 1
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 name "$NAME1"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 command "$SAVE_COPY_SCRIPT"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH1 binding "$KEY1"

# Shortcut 2
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 name "$NAME2"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 command "$COPY_ONLY_SCRIPT"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH2 binding "$KEY2"

echo ""
echo "✅ Flashless screenshot system installed!"
echo "   • Win + Shift + S → Save + Copy + Notification"
echo "   • Ctrl + Alt + S → Copy Only"
echo ""
echo "📁 Saved scripts in: $SCRIPT_DIR"
echo "📸 Screenshots saved in: ~/Pictures/Screenshots/"
