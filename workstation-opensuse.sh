echo "Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null

echo "Updating package lists..."
sudo zypper refresh
echo "Installing Visual Studio Code..."
sudo zypper install code -y

echo "Installing Steam..."
sudo zypper install steam -y

echo "Installing Discord..."
sudo zypper install discord -y