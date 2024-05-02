# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
VENV_ACTIVE=false
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
HISTSIZE=-1
HISTFILESIZE=-1

searchquotes(){
 quote_to_search="$@"
 if [ $quote_to_search ]
 then
 quote_files="$(grep  ${quote_to_search} $HOME/.scripts/quotes/* | awk -F ':' '{print $1}'| uniq )"
 else
	quote_files="$(ls $HOME/.scripts/quotes/*)"
 fi
 (printf "\e[0;3;2m"
 for i in ${quote_files}
 do
	cat $i ;echo -e "\n\n" 
 done
 printf "\033[0m") | batcat --file-name "quotes"

 printf "\e[0m"
}


quotes(){
printf "\e[0;2;3m"
cat $(ls $HOME/.scripts/quotes/* $HOME/.scripts/enlightenment/* | shuf | head -1)
printf "\e[0m"
}
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
PS1='[\[\033[0;32;3;1m\]\u\[\033[0m\]:\[\033[0;1;34m\]\w\[\033[00m\]]:-> '

###########[ Functions ]#################


j_n() {
	new_dir="$(find $HOME -type d  | fzf --preview='tree {}')"
	[ "$new_dir" ]
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	cd "${new_dir}"
	new_dir="$(pwd)"
	echo "$new_dir" >> ~/.cd_history
	fi
}

j() {
	new_dir="$(sort_cd_history | fzf --height=10% --tac)"
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	cd "${new_dir}"
	echo "$new_dir" >> ~/.cd_history
	fi
}

k() {
	curr_dir="$old_dir"
	[ "$(grep "$old_dir" ~/.cd_history)" ] || echo "$old_dir" >> ~/.cd_history
	old_dir="$(pwd)"
	cd "$curr_dir"
	[ "$(grep "$curr_dir" ~/.cd_history)" ] || echo "$curr_dir" >> ~/.cd_history
}

searchpkg() {
	unbuffer nala search "$@"  | less -R
}

picktheme() {
	bg="$(sel_img $(find $HOME/Pictures/Backgrounds -type d))"
	if [ "$bg" ]
	then
	settheme "$bg" $@
	setbg "$bg"
	fi

}

cd() {
old_dir="$(pwd)" 
[ "$(grep "$old_dir" ~/.cd_history)" ] || echo "$old_dir" >> ~/.cd_history

new_dir="$1"	
[ "$new_dir" ] || new_dir="$HOME"
new_dir="$(realpath "${new_dir}")"
command cd "$new_dir"
[ "$new_dir" ] && echo "$new_dir" >> ~/.cd_history
}


#########################################
eval "$(dircolors -b)"
###########[ Aliases ]###############
alias activate='source $HOME/venv/bin/activate' 
alias feh='feh -B black --scale-down --keep-zoom-vp'
alias rm='trash'
alias r="pickup -r"
alias less='less -RM'
alias tt="cat ~/Documents/endsem_schedule.txt"
alias ..='cd .. && echo "$(pwd)" >> ~/.cd_history'
alias red="printf '\033[32;3m' ; read -e ; printf '\033[0m'"
alias bat='batcat'
alias python='python3'
alias ls='ls --color=auto'
#alias cd='old_dir="$(pwd)" && cd'
alias pd='find $HOME -type d | fzf '
alias pf='find $HOME ! -type d | fzf '
alias subplay='mpv --no-video  --player-operation-mode=pseudo-gui -fs'
alias sudo='sudo '
alias apt='nala'
alias cal='ncal'
alias ll='ls -lh'
alias la='ls -lAh'
alias lt='ll -t'
alias ddg='links https://lite.duckduckgo.com/lite'
alias schedule='vi $HOME/.scripts/schedule/schedule.md'
alias filsrc="filsrc -m=fzf"
alias tl='vi $HOME/.scripts/todo/list.md'
alias cando='vi $HOME/.scripts/cando/cando.md'
alias :q='exit'
alias ytbrowse='ytbrowse -m="fzf -m"'
alias :h='info bash'
alias zathura='zathura --mode fullscreen'
alias infread='nano -0 -i -x -t /tmp/nano_temp && rm /tmp/nano_temp'
#alias sudo='doas --'
#####################################
if [ -f ~/.bash_aliases ]
then
	source ~/.bash_aliases
fi

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
EDITOR="nvim"
#source $HOME/venv/bin/activate
#quotes
#cat $HOME/.cache/wal/sequences
. "$HOME/.cargo/env"
