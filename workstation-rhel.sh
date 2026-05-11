@echo "Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

echo "Updating package lists..."
sudo dnf check-update
echo "Installing Visual Studio Code..."
sudo dnf install code

@echo "installing steam..."
sudo dnf install steam

@echo "installing discord..."
sudo dnf install discord 