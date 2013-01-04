#!/bin/bash
#Imports gnome-terminal colors from Xresources/Xdefaults
#Copyright: Rxtx Project <nodiscc@gmail.com>
#License: MIT (http://opensource.org/licenses/MIT)
#TODO: support getting Xresources colors from 'define' parameters, like "#define t_red #ff9da4"

XRESFILE="$1"
number=0
while [ $number -lt 16 ]
do
        ARRAY=`echo $ARRAY ; grep -e "*color$number\:" $XRESFILE | awk '{print $2}'`
        number=$(($number+1))
done

GCONFVALUE=`echo $ARRAY | sed 's/\ /\:/g'`
X_BACKGROUNDVALUE=`grep background $XRESFILE | awk '{print $2}'`
X_FOREGROUNDVALUE=`grep foreground $XRESFILE | awk '{print $2}'`

BACKGROUNDVALUE_PART1=${X_BACKGROUNDVALUE:1:2}
BACKGROUNDVALUE_PART2=${X_BACKGROUNDVALUE:3:2}
BACKGROUNDVALUE_PART3=${X_BACKGROUNDVALUE:5:2}
BACKGROUNDVALUE="#$BACKGROUNDVALUE_PART1$BACKGROUNDVALUE_PART1$BACKGROUNDVALUE_PART2$BACKGROUNDVALUE_PART2$BACKGROUNDVALUE_PART3$BACKGROUNDVALUE_PART3"

FOREGROUNDVALUE_PART1=${X_FOREGROUNDVALUE:1:2}
FOREGROUNDVALUE_PART2=${X_FOREGROUNDVALUE:3:2}
FOREGROUNDVALUE_PART3=${X_FOREGROUNDVALUE:5:2}
FOREGROUNDVALUE="#$FOREGROUNDVALUE_PART1$FOREGROUNDVALUE_PART1$FOREGROUNDVALUE_PART2$FOREGROUNDVALUE_PART2$FOREGROUNDVALUE_PART3$FOREGROUNDVALUE_PART3"

gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/palette "$GCONFVALUE"
gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/foreground_color "$FOREGROUNDVALUE"
gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/background_color "$BACKGROUNDVALUE"

echo "Colors set to $GCONFVALUE"
echo "Foreground set to $FOREGROUNDVALUE"
echo "Background set to $BACKGROUNDVALUE"

ARRAY=""
