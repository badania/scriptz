#!/bin/bash
#Create a link to a package's official website, using dokuwiki syntax.
#Copyright: nodiscc <nodiscc@æmail.com>
#License: MIT (http://opensource.org/licenses/MIT)


for pack in $@;
do
	HOMEPAGE=`apt-cache show $pack | egrep "^Homepage" | uniq | cut -d " " -f2-`;
	if [ "$HOMEPAGE" != "" ]
		then echo " ([[$HOMEPAGE|Site Officiel]])"
		else echo
	fi
done
