#!/bin/bash

set -e

install_warp() {
    if command -v warp-cli >/dev/null 2>&1; then
        echo "WARP already installed."
        return
    fi

    echo "Installing Cloudflare WARP..."

    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | \
        sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/cloudflare-client.list >/dev/null

    sudo apt update
    sudo apt install -y cloudflare-warp
}

register_warp() {
    echo "Registering WARP..."
    warp-cli registration new || true
}

connect_warp() {
    echo "Connecting..."
    warp-cli mode warp
    warp-cli connect
}

disconnect_warp() {
    echo "Disconnecting..."
    warp-cli disconnect
}

status_warp() {
    warp-cli status
}

menu() {
    echo ""
    echo "========= Cloudflare WARP Manager ========="
    echo "1) Install WARP"
    echo "2) Register"
    echo "3) Connect"
    echo "4) Disconnect"
    echo "5) Status"
    echo "6) Reset (Re-register)"
    echo "7) Exit"
    echo "==========================================="
    read -p "Select option: " choice

    case $choice in
        1) install_warp ;;
        2) register_warp ;;
        3) connect_warp ;;
        4) disconnect_warp ;;
        5) status_warp ;;
        6) 
            disconnect_warp
            warp-cli registration delete || true
            register_warp
            ;;
        7) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
}

while true; do
    menu
done
