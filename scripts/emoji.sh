#!/bin/sh
if [ -z $1 ]
then
cat $HOME/.scripts/emoji/emoji.txt | dmenu -l 30 | cut -f 1 | tr -d '\n '  | xclip -sel clip 
elif [ $1=="-p" ]
then
cat $HOME/.scripts/emoji/emoji.txt | dmenu -l 30 | cut -f 1 | tr -d '\n ' 
fi
