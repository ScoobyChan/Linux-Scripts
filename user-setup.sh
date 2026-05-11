#!/bin/bash
#Generate SSH key
ssh-keygen -t ed25519 -b 4096 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_ed25519 -N ""

# setup git
git config --global user.name "$(whoami)"
git config --global user.email "$(whoami)@$(hostname)"

# setup vim
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/undo
echo "set backupdir=~/.vim/backup" >> ~/.vimrc
echo "set directory=~/.vim/swap" >> ~/.vimrc
echo "set undodir=~/.vim/undo" >> ~/.vimrc
echo "set number" >> ~/.vimrc
echo "syntax on" >> ~/.vimrc
echo "set tabstop=4" >> ~/.vimrc
echo "set shiftwidth=4" >> ~/.vimrc
echo "set expandtab" >> ~/.vimrc

# setup python
mkdir -p ~/.local/bin
echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.bashrc

# setup bash profile

curl -fsSL https://raw.githubusercontent.com/fayadlinux/dotfiles/main/bashrc -o ~/.bashrc
curl -fsSL https://raw.githubusercontent.com/fayadlinux/dotfiles/main/bash_profile -o ~/.bash_profile 
curl -fsSL https://raw.githubusercontent.com/fayadlinux/dotfiles/main/aliases -o ~/.aliases

source ~/.bashrc
source ~/.bash_profile