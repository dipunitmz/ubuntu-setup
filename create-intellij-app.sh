#!/bin/bash

# IntelliJ IDEA paths
IDEA_BIN="/home/dipu/Downloads/idea-2025.3.1/idea-IU-253.29346.138/bin"
DESKTOP_FILE="$HOME/.local/share/applications/intellij-idea.desktop"

# Create applications directory if it doesn't exist
mkdir -p "$HOME/.local/share/applications"

# Create the .desktop file
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA
Comment=JetBrains IntelliJ IDEA IDE
Exec=$IDEA_BIN/idea.sh
Icon=$IDEA_BIN/idea.png
Terminal=false
Categories=Development;IDE;
StartupWMClass=jetbrains-idea
EOF

# Make the desktop file executable
chmod +x "$DESKTOP_FILE"

echo "✅ IntelliJ IDEA application entry created successfully!"
echo "You can now search for 'IntelliJ IDEA' in the Applications menu."
