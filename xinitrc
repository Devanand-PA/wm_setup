#!/bin/sh
PATH="$HOME/.local/bin:$PATH"
xcompmgr -n &
export bg="$(cat $HOME/.cache/wal/wal)"
dwm_statusbar_c &

#redshift &
xwallpaper --zoom /usr/share/wallpapers/wal
#xsetroot -solid "#ff0000"
