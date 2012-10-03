#!/bin/bash
#Script used to change resolution to a non-natively supported one.
#Works on Intel cards.
#
#Thanks to barti_ddu
#http://superuser.com/questions/347437/xorg-how-to-specify-a-non-standard-display-resolution
#
#https://rxtx-linux.googlecode.com/
#https://creativecommons.org/licenses/by-nc-sa/3.0/
#
#TODO other resolutions


echo "creating mode line for Xrandr..."
xrandr --newmode "976x600_60.00"   46.50  976 1016 1112 1248  600 603 613 624 -hsync +vsync
echo "adding mode to Xrandr..."
xrandr --addmode LVDS1 976x600_60.00
echo "Switching Xrandr to new mode..."
xrandr --output LVDS1 --mode 976x600_60.00 --set "scaling mode" Center
