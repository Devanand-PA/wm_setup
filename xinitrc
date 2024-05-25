#!/bin/sh
PATH="$HOME/.local/bin:$PATH"
#mpv ~/Music/Sounds/r.opus &
#cd $HOME/Desktop
#picom &
xcompmgr -n &
#slstatus &
#export bg="$( ls $HOME/Pictures/Backgrounds/Snow/* | shuf | sed 1q)"
export bg="$(cat $HOME/.cache/wal/wal)"
dwm_statusbar_c &

#wal -i "$bg" -o $HOME/.scripts/walscript > wal.log
#redshift &
#sh ~/.fehbg
xwallpaper --zoom /usr/share/wallpapers/wal
#xsetroot -solid "#ff0000"
#amixer set -c 0 Headphone unmute 80%
#emacs --daemon 
