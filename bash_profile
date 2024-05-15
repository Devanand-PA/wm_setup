#!/bin/sh
export DENO_INSTALL="/home/devanandpa/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export "$(dbus-launch)"
[ "$(tty)" = "/dev/tty1" ] && startx
. "$HOME/.cargo/env"
