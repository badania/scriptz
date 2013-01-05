#!/bin/bash
#Finds all lines containing "Paquets" in the wiki, outputs a nice list of links to packages.debian.org
#TODO: make it replace $LINE with $FULL_NEW_LINE in the file (see line 19)

WIKIPAGE="$1"

grep Paquets $WIKIPAGE | while read LINE # for each line matching "Paquets"
do
	LINE_PACKAGES_ONLY=`echo $LINE | cut -f2- -d ' ' | sed 's|//||g'` #output only package names
	for PACKAGE in $LINE_PACKAGES_ONLY #for each package name
	do
		PACKAGE_LINK="[[http://packages.debian.org/wheezy/$PACKAGE|$PACKAGE]]" #create a link to the package page
		LINE_PACKAGE_LINKS="$LINE_PACKAGE_LINKS $PACKAGE_LINK" #append the links togeteher
	done
	FULL_NEW_LINE="//Paquets: $LINE_PACKAGE_LINKS //" #recreate the correct dw syntax
	echo $FULL_NEW_LINE #output the full line with links
	echo
#	grep "$LINE" $WIKIPAGE #this works as expected, finds $LINE in $WIKIPAGE
#	sed -i 's|$LINE|$FULL_NEW_LINE|g' $WIKIPAGE #for some reasob, this does not replace $LINE with $FULL_NEW_LINE...
#	Reinitialize variables
	FULL_NEW_LINE=""
	LINE_PACKAGES_ONLY=""
	LINE_PACKAGE_LINKS=""
	PACKAGE_LINK=""
	PACKAGE=""
done
