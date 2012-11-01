#!/bin/bash
#replace iceweasel's taskbar icon with a nicer one (from Faenza icon theme)
#idea from http://crunchbanglinux.org/wiki/howto/change_iceweasel_icon

cd /usr/share/iceweasel/chrome/icons/default &&
sudo mv default16.png default16.png.bak
sudo mv default32.png default32.png.bak
sudo mv default48.png default48.png.bak
sudo ln -s /usr/share/icons/Faenza/apps/16/iceweasel.png default13.png
sudo ln -s /usr/share/icons/Faenza/apps/32/iceweasel.png default32.png
sudo ln -s /usr/share/icons/Faenza/apps/48/iceweasel.png default48.png

#more icon changes
sudo cp /usr/share/icons/Faenza/apps/48/bleachbit.png /usr/share/pixmaps/bleachbit.png
#TODO do the same for unison, gcolor2, zim, liferea
