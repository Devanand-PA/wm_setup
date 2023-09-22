#!/bin/sh
Debian_deps="gcc make libxinerama-dev libxft-dev fontconfig fonts-liberation libx11-dev xinit x11-session-utils build-essential"
Arch_deps="libxinerama libxft fontconfig ttf-liberation xorg-xinit curl wget base-devel"
Common_utils="fonts-jetbrains-mono alsa-utils acpi neovim links sxiv mpv fzf curl wget htop brightnessctl"
sudo pacman -Sy $Arch_deps $Common_utils ||  sudo apt install $Debian_deps $Common_utils

cd dwm/
sudo make clean install
cd ../dmenu/
sudo make clean install
cd ../st/
sudo make clean install
cd ../slstatus/
sudo make clean install
cd ..

cp $HOME/.bashrc $HOME/.bashrc."$(date +%s%N)".bak
cp bashrc $HOME/.bashrc

cp $HOME/.xinitrc $HOME/.xinitrc."$(date +%s%N)".bak
cp xinitrc $HOME/.xinitrc

cp $HOME/.bash_profile $HOME/.bash_profile."$(date +%s%N)".bak
cp bash_profile $HOME/.bash_profile

mkdip -p $HOME/.local/bin
cp scripts/ $HOME/.local/bin/
