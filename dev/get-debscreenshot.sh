#!/bin/bash
#For each specified package, fetches a large screenshot from s.d.n and places it in a subdir
#TODO: colorize output
#TODO: report errors (CURLOPTS)


USERAGENT="Mozilla/4.0, debscreenshotgrabber"
SCREENSHOTSDIR="$PWD"
#PACKAGES=$(cat $1|egrep -v "\#"|tr "\n" " ")
PACKAGES="$@"
NEWFILES=""
NOTFOUND=""

for PACKAGE in $PACKAGES
do
	for SCREENSHOT in `curl -s -A "$USERAGENT" -f http://screenshots.debian.net/package/$PACKAGE | grep "large.png" | cut -f 4 -d "\""`
	do
		FILENAME=$PACKAGE-`basename $SCREENSHOT`
		if [ -f $FILENAME -o -f "$SCREENSHOTSDIR/accepted/$FILENAME" -o -f "$SCREENSHOTSDIR/rejected/$FILENAME" -o -f "$SCREENSHOTSDIR/uploaded/$FILENAME" ]
		then echo "File $FILENAME already exists, skipping..."
		else wget -U "$USERAGENT" -nv -O $FILENAME http://screenshots.debian.net/$SCREENSHOT
		NEWFILES="$NEWFILES $FILENAME"
		sleep 3;
		fi
	done
	ls $SCREENSHOTSDIR/$PACKAGE* &>/dev/null #TODO: this is bad
	PACKAGEFOUND="!$"
	if [ "$PACKAGEFOUND" != "0" ]
	then echo -e "\033[00;31mno screenshots for $PACKAGE\033[00m"
	NOTFOUND="$NOTFOUND $PACKAGE"
	fi
done

echo "Newly retrieved files: $NEWFILES"
echo  -e "\033[00;31mPackages without screenshots: $NOTFOUND\033[00m"
