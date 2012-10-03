#!/bin/bash
#For each specified package, fetches a large screenshot from s.d.n and places it in a subdir
#TODO: test everything, enhance everything

for PACKAGE in pybackpack osmo evolution
do
	mkdir $PACKAGE
	cd $PACKAGE
	for SCREENSHOT in `curl -s -f http://screenshots.debian.net/package/$PACKAGE | grep "large.png" | cut -f 4 -d "\""`
	do wget http://screenshots.debian.net/$SCREENSHOT
	done
	cd ..
done

