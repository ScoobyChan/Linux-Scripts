echo "Installing Visual Studio Code..."
cd
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin
makepkg -si

cd
echo "Installing Steam..."
git clone https://aur.archlinux.org/steam.git
cd steam
makepkg -si

cd
echo "Installing Discord..."
git clone https://aur.archlinux.org/discord.git
cd discord
makepkg -si