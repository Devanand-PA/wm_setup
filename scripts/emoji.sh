#!/bin/sh
if [ -z $1 ]
then
cat $HOME/.scripts/emoji/*.txt| dmenu -l 30 -i | awk '{print $1}' | tr -d '\n '  | xclip -sel clip 
elif [ $1=="-p" ]
then
cat $HOME/.scripts/emoji/*.txt | dmenu -l 30 -i | awk '{print $1}' | tr -d '\n ' 
fi
