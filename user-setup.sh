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

# setup bash profile
current_date=$(date +%Y%m%d%H%M%S)
cp ~/.bashrc ~/.bash_rc_backup_$current_date
cp ~/.bash_profile ~/.bash_profile_$current_date

if [ -f ~/.bash_aliasrc ]; then
    cp ~/.bash_aliasrc ~/.bash_aliasrc_backup_$current_date
fi

curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/bashrc.sh -o ~/.bashrc
curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/bash_profile.sh -o ~/.bash_profile
curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/bash_aliasrc.sh -o ~/.bash_aliasrc

sed -i 's/\r$//' ~/.bashrc

source ~/.bashrc
source ~/.bash_profile
