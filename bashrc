# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=10000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
PS1='[\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]]:-> '

###########[ Functions ]#################
todolist() {
printf "\033[01;32mStaring at a computer will not help you. Take up a book and study \033[00m\n"
}


j() {
	cd "$(find $HOME -type d | fzf --preview="tree {}")"
}

searchpkg() {
	unbuffer nala search "$@"  | less -r
}

#########################################


###########[ Aliases ]###############
alias activate='source $HOME/venv/bin/activate' 
alias ..='cd ..'
alias bat='batcat'
alias python='python3'
alias ls='ls --color=auto'
alias pd='find $HOME -type d | fzf '
alias pf='find $HOME ! -type d | fzf '
alias subplay='mpv --no-video  --player-operation-mode=pseudo-gui -fs'
alias sudo='sudo '
alias apt='nala'
alias cal='ncal'
alias ll='ls -lh'
alias la='ls -lAh'
alias ddg='links https://lite.duckduckgo.com/lite'
alias listen='vi $HOME/.scripts/listen/listen.md'
alias schedule='vi $HOME/.scripts/schedule/schedule.md'
alias tl='vi $HOME/.scripts/todo/list.md'
alias cando='vi $HOME/.scripts/cando/cando.md'
alias :q='exit'
alias :h='info bash'
#####################################

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#################[Scripts to be run after starting bashrc]################
#todolist

set -o vi
EDITOR=nvim
