#!/bin/sh
PATH="$HOME/.local/bin:$PATH"
#cd $HOME/Desktop
picom &
slstatus &
export bg="$( ls $HOME/Pictures/Backgrounds/Mountain_Green/* | shuf | sed 1q)"
#export bg="$(cat $HOME/.cache/wal/wal)"

#wal -i "$bg" -o $HOME/.scripts/walscript > wal.log
xwallpaper --zoom "$bg"
#amixer set -c 0 Headphone unmute 80%
exec dwm
