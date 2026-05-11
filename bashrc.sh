#######################
#### .bashrc linux ####
#######################

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if [[ ":$PATH:" != *":$HOME/.local/bin:$HOME/bin:"* ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specified aliases and functions
cdls() {
    if [[ -z "$1" ]]; then
        cd
    else
        cd "$1"
    fi

    if command -v dircolors >/dev/null 2>&1; then
        ls --color=auto -l
    else
        ls -l
    fi
}
export -f cdls

# Split your login up for
# ps -ef | grep [l]ogin
export _U1="${USER:0:1}"
export _U2="${USER: -7:8}"

# Load extra aliases
[[ -f ~/.bash_aliasrc ]] && source ~/.bash_aliasrc

#### FINISH .bashrc ####
