#!/bin/sh
Debian_deps="gcc make libxinerama-dev libxft-dev fontconfig fonts-liberation libx11-dev xinit x11-session-utils build-essential fonts-noto-cjk-extra fonts-font-awesome libxcb-xinerama0-dev libxcb1-dev libx11-xcb-dev libx11-xcb-dev bsdmainutils libxcb-res0-dev build-essential make alacritty python3-venv "
Arch_deps="libxinerama libxft fontconfig ttf-liberation xorg-xinit curl wget base-devel alacritty"
Common_utils="fonts-jetbrains-mono alsa-utils acpi neovim links sxiv mpv fzf curl wget htop brightnessctl tk"
sudo apt install nala
sudo pacman -Sy $Arch_deps $Common_utils ||  sudo nala  install $Debian_deps $Common_utils
cd dwm/
sudo make clean install
cd ../dmenu/
sudo make clean install
cd ../st/
sudo make clean install
cd ../slstatus/
sudo make clean install
cd ..

## Python
python -m venv $HOME/venv

###[Scripts]########
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.config/Tkinter
cp scripts/* $HOME/.local/bin/
mkdir ~/Trash
mkdir ~/.trash_files/
touch ~/.trash_files/trash_data
