#######################
#### .bash_aliasrc ####
#######################

## Colored alias
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias    ls='ls --color=auto'
    alias   dir='dir --color=auto'
    alias  vdir='vdir --color=auto'

    alias  grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## Normal
alias	    cd='cdls'
alias 	  psme='ps -ef | grep [${_U1}]${_U2}'
alias      vim='vim -Nu ~/.vimrc'
alias      ipr='netstat -nr'
alias      ipa='ifconfig -a'
alias      sss='sudo su -'
alias       df='df -h'
alias      dfi='df -i'
alias       ep='echo $PATH'
alias       vv='$EDITOR ~/.vim_runtime/my_configs.vim'
alias       ra='source  ~/.bash_aliasrc'
alias       va='$EDITOR +4 ~/.bash_aliasrc'
alias       aa='cat     ~/.bash_aliasrc'
alias       pp='cat     ~/.bash_profile'
alias       vp='$EDITOR ~/.bash_profile'
alias       rp='source  ~/.bash_profile'
alias       bb='cat     ~/.bashrc'
alias       vb='$EDITOR ~/.bashrc'
alias       rb='source  ~/.bashrc'
alias       ll='ls -l    --time-style=long-iso'  
alias      lla='ls -la   --time-style=long-iso'
alias      lli='ls -li   --time-style=long-iso'
alias      llz='ls -lZa  --time-style=long-iso'
alias      llt='ls -ltra --time-style=long-iso'
alias   vhosts='sudo vim /etc/hosts'
alias     ping='ping -c 5'
alias  tracert='traceroute'
alias      cls='clear'
alias        a='alias'
alias     svim='sudo vim'
alias   vfstab='sudo vim /etc/fstab'
alias   pretty='cat /etc/os-release | grep PRETTY'
alias     sshd='ssh -vv $1'
alias testcron='sudo run-parts /etc/cron.daily'
alias    ecron='sudo vim /var/spool/cron/crontabs/root'

## Network Commands
alias    oport='nmap -p 1-65535  127.0.0.1'
alias   ssport='sudo ss -tupln'
alias     tcpf='sudo netstat -ano -p tcp | grep $1'
alias    vdhcp='sudo vim  /etc/dhcp/dhclient.conf'
alias    vdnsm='sudo vim /etc/dnsmasq.conf'
alias  dlogipt='tail -f /var/log/kern.log'
alias  flogipt='sudo tail -f /var/log/messages | grep SPT'
alias     ftoi='sudo systemctl stop firewalld && sudo systemctl start iptables && sudo systemctl start ip6tables'
alias     itof='sudo systemctl start firewalld && sudo systemctl stop iptables && sudo systemctl stop ip6tables'

# IPtables
alias     ipta='sudo iptables -P INPUT ACCEPT && sudo iptables -P OUTPUT ACCEPT'
alias     iptd='sudo iptables -P INPUT DROP && sudo iptables -P OUTPUT DROP'
alias     iptl='sudo iptables -L -n -v'
alias     iptb='sudo iptables-save >iptables.$(date +"%Y%m%d%H%M").$USER'
alias    portf='lsof -i :${1}'
alias    iptln='sudo iptables -L --line-numbers'
alias     iptr='sudo iptables -F && sudo iptables-save | sudo tee /etc/sysconfig/iptables && sudo systemctl restart iptables'
# alias     ipts='sudo /sbin/iptables-save > /etc/iptables.rules'
alias     ipts='sudo iptables-save | sudo tee /etc/sysconfig/iptables && sudo systemctl restart iptables'
alias    ip6ts='sudo ip6tables-save | sudo tee /etc/sysconfig/ip6tables && sudo systemctl restart ip6tables'
alias     iptl='sudo iptables -A OUTPUT -j LOG && sudo iptables -A INPUT -j LOG && sudo iptables -A FORWARD -j LOG'
alias     vipt='sudo vim /etc/sysconfig/iptables'
alias    vipt6='sudo vim /etc/sysconfig/ip6tables'

## SSH Keygen 
alias    eckey='ssh-keygen -t ecdsa -b 521 -C "${USER}@${HOSTNAME}"'
alias    edkey='ssh-keygen -t ed25519 -b 521 -C "${USER}@${HOSTNAME}"'
alias    catid='cat ~/.ssh/id_ed25519.pub'
alias     cata='cat ~/.ssh/authorized_keys'
alias     aping='ansible -m ping'

## Shutdown services
alias  shutdown='sudo shutdown'
alias    reboot='sudo reboot'

## Fedora SELinux
alias    selinl='sudo semanage fcontext --locallist --list'
alias    vselin='sudo $EDITOR /etc/selinux/config'

#### FINISH .bash_aliasrc ####