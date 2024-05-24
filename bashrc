# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
VENV_ACTIVE=false
case $- in
    *i*) ;;
      *) return;;
esac
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=-1
HISTFILESIZE=-1
shopt -s checkwinsize
shopt -s globstar
PS1='[\[\033[0;32;3;1m\]\u\[\033[0m\]:\[\033[0;1;34m\]\w\[\033[00m\]]:-> '
PROMPT_COMMAND='printf "\033]0;%s\007" "${PWD/#$HOME/"~"}"'

shopt -s autocd
shopt -s xpg_echo
###########[ Functions ]#################
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
quotes(){
printf "\e[0;2;3m"
cat $(ls $HOME/.scripts/quotes/* | shuf | head -1)
printf "\e[0m"
}

o() {
if [ "$1" ]
then
	sel_file="$(realpath "$1")"
	xdg-open "$sel_file" && ( echo "$sel_file" >> ~/.xdg_open_history )
else
	sel_file="$(sort_cd_history -f ~/.xdg_open_history | fzf)"
	[ "$sel_file" ] &&  xdg-open "$sel_file" && ( echo "${sel_file}" >> ~/.xdg_open_history )
fi
unset sel_file
}

#  NOTE : These functions are here for extra `cd` functionality in the interactive bash shell

j_n() {
	new_dir="$(find $HOME -type d  | fzf --preview='tree {}')"
	[ "$new_dir" ]
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	command cd "${new_dir}"
	new_dir="$(pwd)"
	echo "$new_dir" >> ~/.cd_history
	fi
}

j() {
	new_dir="$(sort_cd_history ~/.cd_history -d | fzf --height=10% --tac)"
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	command cd "${new_dir}"
	echo "$new_dir" >> ~/.cd_history
	fi
}

k() {
	curr_dir="$old_dir"
	[ "$(grep "$old_dir" ~/.cd_history)" ] || echo "$old_dir" >> ~/.cd_history
	old_dir="$(pwd)"
	command cd "$curr_dir"
	[ "$(grep "$curr_dir" ~/.cd_history)" ] || echo "$curr_dir" >> ~/.cd_history
}

h(){
	new_dir="$(cat $HOME/.cd_history | fzf --tac)"
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	command cd "${new_dir}"
	[ "$new_dir" ] && echo "$new_dir" >> ~/.cd_history
	fi
}

cd() {
new_dir=""
ARG_STOP=0
for i in "$@"
do
	case "$i" in
		--)
		ARG_STOP=1 ;;
		-* )

		[ "$ARG_STOP"=1 ] || ARGS+=" $i" ;;
		* )
		[ "$i" ] && new_dir="$i" ;;
	esac
done
ARGS_STOP=0
old_dir="$(pwd)" 
[ "$(grep "$old_dir" ~/.cd_history)" ] || echo "$old_dir" >> ~/.cd_history
[ "$new_dir" ] || new_dir="$HOME"
new_dir="$(realpath "${new_dir}")"
command cd "$new_dir" $ARGS && echo "$new_dir" >> ~/.cd_history
}

#########################################
eval "$(dircolors -b)"

#  NOTE : Put all your aliases here.
###########[ Aliases ]###############
alias activate='source $HOME/venv/bin/activate' 
alias thingstodo="vi ~/.peronal/thingstodo.md"
alias pycalc='python -ic "from numpy import sin , cos , tan , e , pi , log"'
alias sxiv='sxiv -ab'
alias lf='lfrun'
alias feh='feh -B black --scale-down --keep-zoom-vp'
alias rm='trash'
alias l="pickup -l"
alias less='less -RM'
alias tt="cat ~/Documents/endsem_schedule.txt"
#alias ..='cd .. && echo "$(pwd)" >> ~/.cd_history'
alias bat='batcat'
alias python='python3'
alias ls='ls --color=auto'
#alias cd='old_dir="$(pwd)" && cd'
alias pd='find $HOME -type d | fzf '
alias pf='find $HOME ! -type d | fzf '
alias subplay='mpv --no-video  --player-operation-mode=pseudo-gui -fs --sub-pos=55  --no-resume-playback'
#alias sudo='sudo '
#alias apt='nala'
alias cal='ncal'
alias ll='ls -1h'
alias la='ls -lAh'
alias lt='ll -t'
alias schedule='vi $HOME/.scripts/schedule/schedule.md'
alias filsrc="filsrc -m=fzf"
alias tl='vi $HOME/.scripts/todo/list.md'
alias cando='vi $HOME/.scripts/cando/cando.md'
alias :q='exit'
alias ytbrowse='ytbrowse -m="fzf -m"'
alias :h='info bash'
alias zathura='zathura --mode fullscreen'
alias infread='nano -0 -i -x -t /tmp/nano_temp && rm /tmp/nano_temp'
alias c=cd
alias m="man -k . | fzf | awk '{print \$1}' | xargs man"
alias wtr=" curl https://wttr.in"
#alias sudo='doas --'
#
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
EDITOR="nvim"
source $HOME/venv/bin/activate
#quotes
#cat $HOME/.cache/wal/sequences
