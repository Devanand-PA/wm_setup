PATH=$PATH:$HOME/.local/bin
export _JAVA_AWT_WM_NONREPARENTING=1
export $(dbus-launch)
HISTSIZE=999999
HISTFILESIZE=999999
tty="$(tty)"
[ $tty == "/dev/tty1" ] && startx
