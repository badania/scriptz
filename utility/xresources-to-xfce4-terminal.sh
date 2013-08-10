#!/bin/bash
#Description: Imports gnome-terminal colors from Xresources/Xdefaults
#Copyright: Rxtx Project <nodiscc@gmail.com>
#Thanks to u/evaryont at http://redd.it/15z69z
#License: MIT (http://opensource.org/licenses/MIT)
#TODO: does not work for any xdefaults file (see space_supreme.xdefaults)

XRESFILE="$1"
TEMPFILE=""
ARRAY=""

grep -q "define" "$XRESFILE"
if [ "$?" = 0 ]
	then TEMPFILE=`mktemp`
	cpp < "$XRESFILE" > "$TEMPFILE"
	XRESFILE="$TEMPFILE"
fi

number=0
while [ $number -lt 16 ]
do
        ARRAY=`echo $ARRAY ; egrep "URxvt.color$number[\: ]|\*color$number[\: ]" $XRESFILE | egrep -v "^\!"| awk '{print $NF}'`
        number=$(($number+1))
done

GCONFVALUE=`echo $ARRAY | sed 's/\ /\;/g'`
X_BACKGROUNDVALUE=`grep background $XRESFILE | awk '{print $NF}'`
X_FOREGROUNDVALUE=`grep foreground $XRESFILE | awk '{print $NF}'`


BACKGROUNDVALUE_PART1=${X_BACKGROUNDVALUE:1:2}
BACKGROUNDVALUE_PART2=${X_BACKGROUNDVALUE:3:2}
BACKGROUNDVALUE_PART3=${X_BACKGROUNDVALUE:5:2}
BACKGROUNDVALUE="#$BACKGROUNDVALUE_PART1$BACKGROUNDVALUE_PART2$BACKGROUNDVALUE_PART3"

FOREGROUNDVALUE_PART1=${X_FOREGROUNDVALUE:1:2}
FOREGROUNDVALUE_PART2=${X_FOREGROUNDVALUE:3:2}
FOREGROUNDVALUE_PART3=${X_FOREGROUNDVALUE:5:2}
FOREGROUNDVALUE="#$FOREGROUNDVALUE_PART1$FOREGROUNDVALUE_PART2$FOREGROUNDVALUE_PART3"

#gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/palette "$GCONFVALUE"
#gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/foreground_color "$FOREGROUNDVALUE"
#gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/background_color "$BACKGROUNDVALUE"
THEMENAME=`basename $1 | awk -F "\." '{print $1}' 2>/dev/null`

CONTENTS=`
echo "[Scheme]"
echo "Name=${THEMENAME}"
echo "ColorPalette=$GCONFVALUE"
echo "ColorForeground=$FOREGROUNDVALUE"
echo "ColorCursor=$FOREGROUNDVALUE"
echo "ColorBackground=$BACKGROUNDVALUE"`

echo "${CONTENTS}" > "${THEMENAME}".theme

if [ -f "$TEMPFILE" ]
	then rm "$TEMPFILE"
fi
