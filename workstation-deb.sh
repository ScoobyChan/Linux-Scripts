@echo "Installing Visual Studio Code..."
curl -L https://go.microsoft.com/fwlink/?LinkID=760868 --output vscode.deb
sudo apt install ./vscode.deb

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

echo "Adding Microsoft repository..."
curl -L https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm microsoft.gpg

echo "Updating package lists..."
sudo apt update

echo "Installing Visual Studio Code..."
sudo apt install code


@echo "installing steam..."
curl -L https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb --output steam.deb
sudo apt install ./steam.deb

@echo "installing discord..."
curl -L https://dl.discordapp.net/apps/linux/0.0.24/discord-0.0.24.deb --output discord.deb
sudo apt install ./discord.deb 