#!/bin/sh
PATH="$HOME/.local/bin:$PATH"
#cd $HOME/Desktop
#picom &
xcompmgr -n &
#slstatus &
dwm_statusbar_c &
#export bg="$( ls $HOME/Pictures/Backgrounds/Snow/* | shuf | sed 1q)"
export bg="$(cat $HOME/.cache/wal/wal)"

#wal -i "$bg" -o $HOME/.scripts/walscript > wal.log
#redshift &
sh ~/.fehbg
#xwallpaper --zoom "$bg"
#amixer set -c 0 Headphone unmute 80%
#emacs --daemon 
exec dwm
