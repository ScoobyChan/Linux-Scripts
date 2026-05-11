#############################
#### .bash_profile linux ####
#############################

## Get aliases and functions
if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi

## History
export HISTTIMEFORMAT="%F %T: "
export HISTFILESIZE=10000
export HISTSIZE=5000

## VIM
export MYVIMRC="$HOME/.vimrc"
export EDITOR="/usr/bin/vim"

## TTY
_TTY=$(tty | awk -F "/" '{ print $3$4 }')

## HOST OS (3‑letter code)
_HOST_OS=$(uname -s | cut -c 1-3)

## PROMPT (terminal title)
PROMPT_COMMAND='echo -ne "\033]0;${_HOST_OS} - ${_TTY}\007"'

## Bash completion for sudo
complete -cf sudo

## Colors
_LRED="\033[0;91m"
_LGRAY="\033[0;37m"
_LBLUE="\033[0;94m"
_LGREEN="\033[0;92m"
_LYELLOW="\033[0;93m"
_LMAGENTA="\033[0;95m"
_LCYAN="\033[0;96m"

_NC="\033[0m"

_RED="\033[1;31m"
_GREEN="\033[1;32m"
_WHITE="\033[1;37m"
_YELLOW="\033[1;33m"
_MAGENTA="\033[1;35m"
_BLUE="\033[1;34m"
_CYAN="\033[1;36m"

######################
### PROCESS STATUS ###
######################

case "$_HOST_OS" in
  AIX)
    _PS1="\[${_LMAGENTA}\]\$_TTY [$?] \$(date +'%H:%M:%S')\[${_LCYAN}\]\u\[${_LGREEN}\]@\[${_LYELLOW}\]\h\[${_LBLUE}\]:\$PWD\[${_NC}\]\n> "
    ;;
  Lin)
    _PS1="\[${_LMAGENTA}\]\$_TTY [$?] \$(date +'%H:%M:%S')\[${_LCYAN}\]\u\[${_LGREEN}\]@\[${_LRED}\]\h\[${_LBLUE}\]:\$PWD\[${_NC}\]\n> "
    ;;
  *)
    ## Default fallback
    _PS1="\[${_LGREEN}\]\$_TTY [$?] \$(date +'%H:%M:%S')\[${_LMAGENTA}\]\u\[${_LRED}\]@\[${_LYELLOW}\]\h\[${_LGREEN}\]:\$PWD\[${_NC}\]\n> "
    ;;
esac

PS1="${_PS1}"

#### FINISH .bash_profile ####
