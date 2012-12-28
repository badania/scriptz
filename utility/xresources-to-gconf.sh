#!/bin/bash
#Imports gnome-terminal colors from Xresources/Xdefaults
#Source: http://github.com/nodiscc
#License: MIT

XRESFILE="$1"
number=0
while [ $number -lt 16 ]
do
        ARRAY=`echo $ARRAY ; grep -e "*color$number\:" $XRESFILE | awk '{print $2}'`
        number=$(($number+1))
done

GCONFVALUE=`echo $ARRAY | sed 's/\ /\:/g'`
BACKGROUNDVALUE=`grep background $XRESFILE | awk '{print $2}'`
FOREGROUNDVALUE=`grep foreground $XRESFILE | awk '{print $2}'`

gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/palette "$GCONFVALUE"
gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/foreground-color "$FOREGROUNDVALUE"
gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/background-color "$BACKGROUNDVALUE"

echo "Colors set to $GCONFVALUE"
echo "Foreground set to $FOREGROUNDVALUE"
echo "Background set to $BACKGROUNDVALUE"

ARRAY=""
