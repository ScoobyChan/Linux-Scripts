#!/bin/bash
###########################
### Gather Host OS Info ###
###########################

host_os=$(cat /etc/os-release | grep NAME | cut -d "
" -f 1 | cut -d "=" -f 2 | tr -d '"')

# Managers
if command -v apt > /dev/null; then
    echo "APT package manager"
    pac_man="sudo apt"
    auto_conf="-y"
    update="$pac_man update && $pac_man upgrade $auto_conf"
    install="$pac_man install $auto_conf"
elif command -v dnf > /dev/null; then
    echo "DNF package manager"
    pac_man="sudo dnf"
    update="$pac_man update $auto_conf"
    auto_conf="-y"
    install="$pac_man install $auto_conf"
elif command -v zypper > /dev/null; then
    echo "Zypper package manager"
    pac_man="sudo zypper"
    auto_conf="-y"
    update="$pac_man update $auto_conf"
    install="$pac_man install $auto_conf"
elif command -v pacman > /dev/null; then
    echo "Pacman package manager"
    pac_man="sudo pacman"
    auto_conf="--no-confirm"
    update="$pac_man -Syyu $auto_conf"
    install="$pac_man -S $auto_conf"
elif command -v xbps-install > /dev/null; then
    echo "Void package manager"
    pac_man="sudo xbps-install"
    auto_conf="-y"
    update="$pac_man -Su $auto_conf"
    install="$pac_man $auto_conf"
else
    echo "No known package manager found for host $host_os"
    exit
fi

echo $install
