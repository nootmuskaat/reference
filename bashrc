# $HOME/.bashrc
set -o vi
export EDITOR=nvim

# My standared aliases
alias vi="$EDITOR"
alias view="$EDITOR -R"
alias ll='command ls -lA --group-directories-first'
alias ls='command ls -F'
alias o='less'
alias O='less -R'
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias .bashrc="source $HOME/.bashrc"
alias bashrc="${EDITOR} $HOME/.bashrc && .bashrc"
alias which='alias | which -i'
alias ipython='command ipython --colors=NoColor --classic'
alias groovysh='groovysh -Dgroovysh.prompt="{G}" --color=false'
alias irb='irg --prompt simple'

# This is sadly necessary
alias wq="echo you\'re not in vim"
alias q=wq
alias :q=wq
alias :wq=wq


# Generic prompt setup for the most common Linux distros
if [ -e /etc/prompt-setup ]; then
    source /etc/prompt-setup
elif [ -e $HOME/.prompt-setup ]; then
    source $HOME/.prompt-setup
fi

# Any host specific functions or actions
if [[ -f ${HOSTRC:="$HOME/.bashrc_$(hostname)"} ]]; then
    source "$HOSTRC"
fi

function cal() {
    command cal -m -3 -n9 $@ 2>/dev/null || command cal -m -3 $@
}

function sorted() {
    local src="$1"
    local temp="$(mktemp -p $(dirname ${src}))"
    cp "${src}" "${temp}" &&
        sort "${temp}" > "${src}" &&
        rm "${temp}"
}

function exists_and_absent_from_path() {
  for path in "$@"; do
    if [[ -d "${path}" ]] && ! grep -qE '(:|^)'"$path"'(:|$)' <<< "$PATH" ; then
      echo "${path}"
    fi
  done
}

# Add optional PATH
_optional_dirs="$(command ls -d  $HOME/.gem/ruby/*/bin | sort -V) $HOME/.cargo/bin"
for d in $(exists_and_absent_from_path ${_optional_dirs}); do
  export PATH="${d}:$PATH"
done

# If opening a new terminal window, count open tmux sessions
if [[ -z "$TMUX" && -n "$(which tmux)" && -f "$HOME/.tmux.conf" ]]; then
    printf '\e[30;47m %d open tmux sessions \e[m\n' \
        $(tmux ls 2>/dev/null | wc -l)
fi

function mk_pwd() {
  local -ri length=${1:-20}

  python << EOF
import random
import string
chars = string.ascii_letters + string.digits + string.punctuation
print(''.join(random.choice(chars) for _ in range(${length})))
EOF
}
