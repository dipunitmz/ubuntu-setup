#!/usr/bin/env bash
set -Eeuo pipefail

echo "======================================"
echo " Screenshot Selection Setup"
echo "======================================"

# 1. Install required packages
echo "[1/5] Installing packages..."
sudo apt update
sudo apt install -y flameshot xclip libnotify-bin

# 2. Create directories
BIN_DIR="$HOME/.local/bin"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

mkdir -p "$BIN_DIR" "$SCREENSHOT_DIR"

# 3. Check automatic selection support
echo "[2/5] Checking Flameshot options..."

if ! flameshot gui --help 2>&1 | grep -q -- '--accept-on-select'; then
    echo "ERROR: Your Flameshot version does not support"
    echo "--accept-on-select."
    echo "Please update Flameshot to a compatible version."
    exit 1
fi

# 4. Create the screenshot script
echo "[3/5] Creating screenshot script..."

cat > "$BIN_DIR/flashless_save_copy.sh" <<'SCRIPT'
#!/usr/bin/env bash
set -u

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%F_%H-%M-%S).png"

# Select an area; releasing the mouse accepts the selection.
if flameshot gui \
    --accept-on-select \
    --clipboard \
    --path "$FILE"; then

    if [[ -s "$FILE" ]]; then
        notify-send "Screenshot saved and copied" "$FILE"
    else
        notify-send "Screenshot failed" \
            "No image file was created."
        exit 1
    fi
else
    rm -f "$FILE"
    notify-send "Screenshot cancelled" \
        "No screenshot was saved."
fi
SCRIPT

chmod +x "$BIN_DIR/flashless_save_copy.sh"

# 5. Configure Ctrl + Shift + S
echo "[4/5] Configuring keyboard shortcut..."

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
ENTRY="${BASE}custom-flashless-screenshot/"

if ! gsettings list-schemas | grep -qx "$SCHEMA"; then
    echo "ERROR: GNOME custom shortcut schema not found."
    echo "Your desktop may not be GNOME."
    echo "Screenshot script is installed at:"
    echo "$BIN_DIR/flashless_save_copy.sh"
    exit 1
fi

KEY_SCHEMA="${SCHEMA}.custom-keybinding"

# Register our custom shortcut.
# Preserve existing custom shortcuts.
CURRENT=$(gsettings get "$SCHEMA" custom-keybindings)

if [[ "$CURRENT" == "@as []" || "$CURRENT" == "[]" ]]; then
    UPDATED="['$ENTRY']"
elif [[ "$CURRENT" == *"$ENTRY"* ]]; then
    UPDATED="$CURRENT"
else
    UPDATED="${CURRENT%]}"
    UPDATED="${UPDATED}, '$ENTRY']"
fi

gsettings set "$SCHEMA" custom-keybindings "$UPDATED"

gsettings set "$KEY_SCHEMA:$ENTRY" name \
    "Screenshot - Select, Save and Copy"
gsettings set "$KEY_SCHEMA:$ENTRY" command \
    "$BIN_DIR/flashless_save_copy.sh"
gsettings set "$KEY_SCHEMA:$ENTRY" binding \
    "<Ctrl><Shift>s"

echo "[5/5] Setup complete!"
echo
echo "Shortcut: Ctrl + Shift + S"
echo "Behavior: Select region, release mouse,"
echo "          automatically save and copy."
echo "Save folder: $SCREENSHOT_DIR"
echo
echo "Test now with:"
echo "$BIN_DIR/flashless_save_copy.sh"
