#  NOTE : These functions are here for extra `cd` functionality in the interactive bash shell

j_n() {
	new_dir="$(find $HOME -type d  | fzf --preview='tree {}')"
	[ "$new_dir" ]
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	if [ -d "${new_dir}" ]
	then
	command cd "${new_dir}"
	new_dir="$(pwd)"
	[ "$(grep "$new_dir" ~/.cd_history)" ] || echo "$new_dir" >> ~/.cd_history
	echo $new_dir added
	else
	sed "s|^${new_dir}$||g" $HOME/.cd_history  -i
	sed /^$/d $HOME/.cd_history -i
	echo $new_dir removed
	fi
	fi
}

j() {
	new_dir="$(cat ~/.cd_history |  fzf --height=10% --tac)"
	if [ "${new_dir}" ] && [ "$new_dir" != "$(pwd)" ]
	then
	old_dir="$(pwd)"
	if [ -d "${new_dir}" ]
	then
	command cd "${new_dir}"
	[ "$(grep "$new_dir" ~/.cd_history)" ] || echo "$new_dir" >> ~/.cd_history
	echo $new_dir added
	else
	sed "s|^${new_dir}$||g" $HOME/.cd_history  -i
	sed /^$/d $HOME/.cd_history -i
	echo $new_dir removed
	fi
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
	[ "$(grep "$new_dir" ~/.cd_history)" ] || echo "$new_dir" >> ~/.cd_history
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
[ "$new_dir" ] && new_dir="$(realpath "${new_dir}")"
[ "$new_dir" ] || new_dir="$HOME"
[ "$curr_dir" != "$new_dir" ] && old_dir="$(pwd)" 
[ "$(grep "$old_dir" ~/.cd_history)" ] || echo "$old_dir" >> ~/.cd_history
[ "$(grep "$new_dir" ~/.cd_history)" ] || echo $(realpath "$new_dir") >> ~/.cd_history
if [ -d "$new_dir" ]
then
[ "$new_dir" != "$old_dir" ] && command cd "$new_dir" $ARGS 
else
	echo not found "$new_dir"
fi
}

