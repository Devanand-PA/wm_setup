#!/bin/sh
thunderbird --headless &
slstatus &
xwallpaper --zoom $( realpath $HOME/Pictures/images/astro_pic/* | shuf | sed 1q )
#curl https://apod.nasa.gov/apod/ | grep 'a href="image/' | awk -F "\"" '{print $2}' | xargs -I {} wget https://apod.nasa.gov/apod/{} --directory-prefix="$HOME/Pictures/images/astro_pic" --continue &
exec dwm
