#!/bin/bash
#Create a link to a package's page, using dokuwiki/markdown syntax.
#Links are formatted like package_name_and_page_link - package_description - package_homepage
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: (c) 2013 nodiscc <nodiscc@gmail.com>

#Init variables
MARKDOWN=""
ARGS="$@"
USAGE="`basename $0` [OPTIONS] package names
OPTIONS:
    -m    enable markdown mode"

if [ "$1" = "-h" -o "$1" = "" ]
	then echo "$USAGE"
fi

#Check if -m option (markdown mode) is set
if [ "$1" = "-m" ]
	then MARKDOWN=1
	ARGS=`echo "$ARGS" | sed 's/-m //'`
fi

#Run
for pack in $ARGS;
do
	PACKAGE_DESCR=`apt-cache show $pack | egrep "^Description" |egrep -v "Description-md5"| uniq | cut -d " " -f2-`;
	HOMEPAGE=`apt-cache show $pack | egrep "^Homepage" | uniq | cut -d " " -f2-`;

	if [ "$MARKDOWN" = "1" ]
	then #Markdown syntax
		echo -n "[$pack](http://packages.debian.org/wheezy/$pack) - $PACKAGE_DESCR";
		if [ "$HOMEPAGE" != "" ]
		then
			echo " ([Site Officiel]($HOMEPAGE))"
		else
			echo
		fi
	else #Dokuwiki syntax
		echo -n "[[http://packages.debian.org/wheezy/$pack|$pack]] - $PACKAGE_DESCR";
		if [ "$HOMEPAGE" != "" ]
		then
			echo " ([[$HOMEPAGE|Site Officiel]])"
		else
			echo
		fi
	fi
done
