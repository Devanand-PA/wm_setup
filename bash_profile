#!/bin/sh
export DENO_INSTALL="/home/devanandpa/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export "$(dbus-launch)"
#export PATH="$PATH:$HOME/.local/bin:$HOME/.scripts/bin:$HOME/sourced/android-studio/bin"
[ "$(tty)" = "/dev/tty1" ] && startx
. "$HOME/.cargo/env"
