#!/bin/bash
#For each specified package, fetches a large screenshot from s.d.n and places it in a subdir
#TODO: Declare user agent, pause between requests, create thumbnails


for PACKAGE in pybackpack osmo evolution icedove iceweasel owncloud filezilla
do
#	mkdir $PACKAGE
#	cd $PACKAGE
	for SCREENSHOT in `curl -s -f http://screenshots.debian.net/package/$PACKAGE | grep "large.png" | cut -f 4 -d "\""`
		do wget -O $PACKAGE-`basename $SCREENSHOT` http://screenshots.debian.net/$SCREENSHOT
	done
#	cd ..
done

