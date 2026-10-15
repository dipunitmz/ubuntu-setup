#!/usr/bin/env bash
set -Eeuo pipefail

echo "======================================"
echo " Screenshot Setup Uninstaller"
echo "======================================"

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
ENTRY="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-flashless-screenshot/"
KEY_SCHEMA="${SCHEMA}.custom-keybinding"

# 1. Remove our custom GNOME shortcut
echo "[1/4] Removing custom keyboard shortcut..."

if gsettings list-schemas | grep -qx "$SCHEMA"; then
    CURRENT=$(gsettings get "$SCHEMA" custom-keybindings)

    # Remove only our shortcut; preserve other custom shortcuts.
    UPDATED=$(python3 -c '
import ast, sys
entries = ast.literal_eval(sys.argv[1])
target = sys.argv[2]
print(repr([x for x in entries if x != target]))
' "$CURRENT" "$ENTRY")

    gsettings set "$SCHEMA" custom-keybindings "$UPDATED"

    # Remove settings for our custom shortcut.
    if gsettings list-relocatable-schemas | grep -qx "$KEY_SCHEMA"; then
        gsettings reset-recursively "$KEY_SCHEMA:$ENTRY" 2>/dev/null || true
    fi
fi

# 2. Remove scripts created by the installer
echo "[2/4] Removing screenshot scripts..."

rm -f "$HOME/.local/bin/flashless_save_copy.sh"
rm -f "$HOME/.local/bin/flashless_copy_only.sh"

# 3. Restore GNOME animation setting to its default
echo "[3/4] Restoring GNOME animations..."

if gsettings list-schemas | grep -qx "org.gnome.desktop.interface"; then
    gsettings reset org.gnome.desktop.interface enable-animations
fi

# 4. Optionally remove installed packages
echo
read -r -p "Uninstall Flameshot, xclip and libnotify-bin too? [y/N]: " REMOVE_PACKAGES

if [[ "$REMOVE_PACKAGES" =~ ^[Yy]$ ]]; then
    echo "[4/4] Removing packages..."
    sudo apt remove -y flameshot xclip libnotify-bin
    echo "Packages removed. Unused dependencies were not automatically removed."
else
    echo "[4/4] Keeping installed packages."
fi

echo
echo "======================================"
echo " Uninstallation complete!"
echo "======================================"
echo "Your screenshots have NOT been deleted."
echo "Your other custom keyboard shortcuts are preserved."
echo "You may need to restore your previous screenshot shortcut manually."
