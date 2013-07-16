#!/bin/bash
#Create a link to a package's page, using dokuwiki/markdown syntax.
#Links are formatted like package_name_and_page_link - package_description - package_homepage
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: (c) 2013 nodiscc <nodiscc@gmail.com>

#Init variables
MARKDOWN=""
BULLETED=""
USAGE="`basename $0` [OPTIONS] package names
OPTIONS:
    -m    enable markdown mode
    -b    enable bullet list"

#if [ "$1" = "-h" -o "$1" = "" ]
#	then echo "$USAGE"
#fi

#Check options and select appropriate text for bullet lists
while getopts ":mbh" opt; do
	case $opt in
	h)
	echo "$USAGE"
	exit 1
	;;
	m)
	MARKDOWN="1"
	;;
	b)
	BULLETED="1"
	;;
	/?)
	echo "Invalid option: -$OPTARG" >&2
	exit 1;;
	esac
done

if [[ "$MARKDOWN" = "1" && "$BULLETED" = "1" ]]
	then BULLET=" * "
	shift
elif [[ "$MARKDOWN" = "" && "$BULLETED" = "1" ]]
	then BULLET="  * "
	shift
elif [[ "$MARKDOWN" = "1" && "$BULLETED" = "" ]]
	then BULLET=""
	shift
elif [[ "$BULLETED" = "" ]]
	then BULLET=""
fi

#Run
ARGS="$@"
for pack in $ARGS;
do
	PACKAGE_DESCR=`apt-cache show $pack | egrep "^Description" |egrep -v "Description-md5"| uniq | cut -d " " -f2-`;
	HOMEPAGE=`apt-cache show $pack | egrep "^Homepage" | uniq | cut -d " " -f2-`;

	if [ "$MARKDOWN" = "1" ]
	then #Markdown syntax
		echo -n "${BULLET}[$pack](http://packages.debian.org/wheezy/$pack) - $PACKAGE_DESCR";
		if [ "$HOMEPAGE" != "" ]
		then
			echo " ([Site Officiel]($HOMEPAGE))"
		else
			echo
		fi
	else #Dokuwiki syntax
		echo -n "${BULLET}[[http://packages.debian.org/wheezy/$pack|$pack]] - $PACKAGE_DESCR";
		if [ "$HOMEPAGE" != "" ]
		then
			echo " ([[$HOMEPAGE|Site Officiel]])"
		else
			echo
		fi
	fi
done
