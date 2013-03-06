#!/bin/bash
#Create a link to a package's page, using dokuwiki syntax.
#Links are formatted like package_name_and_page_link - package_description - package_homepage
#License: 

for pack in $@;
do
	PACKAGE_DESCR=`apt-cache show $pack | egrep "^Description" |egrep -v "Description-md5"| uniq | cut -d " " -f2-`;
	HOMEPAGE=`apt-cache show $pack | egrep "^Homepage" | uniq | cut -d " " -f2-`;
	echo -n "[[http://packages.debian.org/wheezy/$pack|$pack]] - $PACKAGE_DESCR";
	if [ "$HOMEPAGE" != "" ]
		then echo " ([[$HOMEPAGE|Site Officiel]])"
		else echo
	fi
done
