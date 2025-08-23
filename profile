#!/bin/sh
 xset r rate 300 60
# setxkbmap -option caps:swapescape
#xmodmap ~/.Xmodmap
export DENO_INSTALL="/home/devanandpa/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

#export "$(dbus-launch)"
#export PATH="$PATH:$HOME/.local/bin:$HOME/.scripts/bin:$HOME/sourced/android-studio/bin"
export PATH="/usr/sbin/:$PATH:$HOME/.local/bin:$HOME/.scripts/bin:$HOME/sourced/android-studio/bin:$HOME/sourced/build_linux/bin:$HOME/sourced/blender-4.1.1-linux-x64:$HOME/.cargo/bin:"
[ "$(tty)" = "/dev/tty1" ] && startx
#export WM_SETUP_DIR='/home/devanandpa/sourced/wm_setup'
export WM_SETUP_DIR='/home/devanandpa/sourced/wm_setup'
