# $HOME/.bashrc
# My standared aliases
alias vi='vim'
alias ls='ls -F'
alias ll='\ls -lAX'
alias o='less'
alias O='less -R'
alias cgrep='grep --color=always'
alias .bashrc='source $HOME/.bashrc'
alias bashrc='vi $HOME/.bashrc && .bashrc'
alias which='alias | which -i'

# Generic prompt setup for the most common Linux distros
if [ -e /etc/prompt-setup ]; then
    # alternatively $HOME/.prompt-setup
    source /etc/prompt-setup
fi

# Any host specific functions or actions
HOSTRC="$HOME/.bashrc_$(hostname)"
if [ -f $HOSTRC ]; then
    source $HOSTRC
fi
