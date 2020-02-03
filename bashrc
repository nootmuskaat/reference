# $HOME/.bashrc

# My standared aliases
alias vi='vim'
alias view='vim -R'
alias ll='command ls -lA --group-directories-first'
alias ls='command ls -F'
alias o='less'
alias O='less -R'
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias .bashrc='source $HOME/.bashrc'
alias bashrc='vi $HOME/.bashrc && .bashrc'
alias which='alias | which -i'
alias ipython='command ipython --colors=NoColor --classic'
alias groovysh='groovysh -Dgroovysh.prompt="{G}" --color=false'

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

function cal() {
    command cal -m -3 -n9 $@ 2>/dev/null || /bin/cal -m -3 $@
}

function sorted() {
    local src="$1"
    local temp="$(mktemp -p $(dirname ${src}))"
    cp "${src}" "${temp}" &&
        sort "${temp}" > "${src}" &&
        rm "${temp}"
}
