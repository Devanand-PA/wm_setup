#!/bin/sh
if [ -z $1 ]
then
cat $HOME/.scripts/emoji/*.txt| rofi -dmenu -i | awk '{print $1}' | tr -d '\n '  | xclip -sel clip 
elif [ $1=="-p" ]
then
cat $HOME/.scripts/emoji/*.txt | rofi -dmenu -i | awk '{print $1}' | tr -d '\n ' 
fi
