#######################
#### .bashrc linux ####
#######################

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specified aliases and functions
function cdls() {
	[[ -z "$1" ]] && _CD="cd" || _CD="cd $1"
	${_CD};
	if [ -x /usr/bin/dircolors ]; then
    ls --color=auto -l
  else
    ls
  fi
}
export -f cdls

## split your login up for
### ps -ef | grep [l]ogin
export _U1=${USER: :1}
export _U2=${USER: -7:8}

[[ -f ~/.bash_aliasrc ]] && source ~/.bash_aliasrc

#### FINISH .bashrc ####
