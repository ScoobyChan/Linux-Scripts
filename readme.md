execute:
curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/user-setup.sh | sh

For solo updates:
curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/bashrc.sh -o ~/.bashrc
curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/bash_profile.sh -o ~/.bash_profile
curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/bash_aliasrc.sh -o ~/.bash_aliasrc

dos2unix ~/.bashrc
dos2unix ~/.bash_profile
dos2unix ~/.bash_aliasrc

source ~/.bashrc
source ~/.bash_profile
