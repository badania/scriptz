#!/bin/bash
#Description: Script used to change resolution to a non-natively supported one.
#Works on Intel cards.
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: Rxtx Project <nodiscc@gmail.com>
#Thanks to barti_ddu at http://superuser.com/questions/347437
#TODO other resolutions


echo "creating mode line for Xrandr..."
xrandr --newmode "976x600_60.00"   46.50  976 1016 1112 1248  600 603 613 624 -hsync +vsync
echo "adding mode to Xrandr..."
xrandr --addmode LVDS1 976x600_60.00
echo "Switching Xrandr to new mode..."
xrandr --output LVDS1 --mode 976x600_60.00 --set "scaling mode" Center
