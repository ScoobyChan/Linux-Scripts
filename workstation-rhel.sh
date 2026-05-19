echo "Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

echo "Updating package lists..."
sudo dnf check-update
echo "Installing Visual Studio Code..."
sudo dnf install code -y

#!/bin/bash
curl -fsSL https://tailscale.com/install.sh | sh
# Flatpak apps
sudo dnf install flatpak
flatpak remote-delete flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub trayscale -y
flatpak install flathub 
