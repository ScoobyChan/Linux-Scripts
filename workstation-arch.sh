@echo "Installing Visual Studio Code..."

git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin
makepkg -si

@echo "installing steam..."
git clone https://aur.archlinux.org/steam.git
cd steam
makepkg -si

@echo "installing discord..."
git clone https://aur.archlinux.org/discord.git
cd discord
makepkg -si