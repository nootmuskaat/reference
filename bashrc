# $HOME/.bashrc

# My standared aliases
alias vi='vim'
alias ll='\ls -lA'
alias ls='ls -F'
alias o='less'
alias O='less -R'
alias cgrep='grep --color=always'
alias .bashrc='source $HOME/.bashrc'
alias bashrc='vi $HOME/.bashrc && .bashrc'
alias which='alias | which -i'
alias cal='cal -m3n9'
# This is sadly necessary
alias wq="echo you\'re not in vim"
alias q=wq
alias :q=wq
alias :wq=wq

export EDITOR=vim

function retmux() {
    NUM_TMUX_SES=$(tmux list-sessions 2>/dev/null | wc -l)
    if [ $NUM_TMUX_SES -gt 1 ]; then
        echo "More than 1 tmux session; reattach with tmux attach -t"
        tmux list-sessions
    elif [ $NUM_TMUX_SES -eq 0 ]; then
        echo "No open tmux sessions"
    else
        SES=$(tmux list-sessions | awk -F':' '{ print $1 }')
        tmux attach-session -t $SES
    fi
}

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
