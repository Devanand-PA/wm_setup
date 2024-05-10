#!/bin/sh
Debian_deps="gcc make libxinerama-dev libxft-dev fontconfig fonts-liberation libx11-dev xinit x11-session-utils build-essential fonts-noto-cjk-extra fonts-font-awesome libxcb-xinerama0-dev libxcb1-dev libx11-xcb-dev libx11-xcb-dev bsdmainutils libxcb-res0-dev build-essential make alacritty python3-venv fonts-firacode"
Arch_deps="libxinerama libxft fontconfig ttf-liberation xorg-xinit curl wget base-devel alacritty ttf-fira-code"
Common_utils="fonts-jetbrains-mono alsa-utils acpi neovim links sxiv mpv fzf curl wget htop brightnessctl tk"

dist=$(lsb_release -i | grep ID | awk -F ':\t' '{print $2}')
case $dist in
	"Debian" | "Ubuntu")
		#sudo apt install nala && alias apt=nala
		sudo apt install $Debian_deps $Common_utils --no-install-recommends ;;

	"Arch" )
	sudo pacman -Sy $Arch_deps $Common_utils ;;
esac


cd dwm/
sudo make clean install
cd ../dmenu/
sudo make clean install
cd ../st/
sudo make clean install
cd ../dwm_status/
sudo make clean install
cd ..

## Python
python -m venv $HOME/venv

###[Scripts]########
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.scripts/bin/
mkdir -p $HOME/.config/Tkinter
cp scripts/* $HOME/.scripts/bin/
chmod +x $HOME/.scripts/bin/*
mkdir ~/Trash
mkdir ~/.trash_files/
touch ~/.trash_files/trash_data
