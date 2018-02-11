# $HOME/.bashrc

# My standared aliases
alias vi='vim'
alias ll='\ls -lA'
alias ls='ls -F'
alias o='less'
alias O='less -R'
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias .bashrc='source $HOME/.bashrc'
alias bashrc='vi $HOME/.bashrc && .bashrc'
alias which='alias | which -i'
alias cal='cal -m3n9'
alias gdb='gdb -q'
# This is sadly necessary
alias wq="echo you\'re not in vim"
alias q=wq
alias :q=wq
alias :wq=wq

export EDITOR=vim

# Generic prompt setup for the most common Linux distros
if [ -e /etc/prompt-setup ]; then
    source /etc/prompt-setup
elif [ -e $HOME/.prompt-setup ]; then
    source $HOME/.prompt-setup
fi

# Any host specific functions or actions
HOSTRC="$HOME/.bashrc_$(hostname)"
if [ -f $HOSTRC ]; then
    source $HOSTRC
fi
