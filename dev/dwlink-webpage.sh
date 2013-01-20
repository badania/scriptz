#!/bin/bash
#Create a link to an URL using dokuwiki syntax. (Using page title as the link text)
#License: MIT (http://opensource.org/licenses/MIT)


for URL in $@;
do
	TITLE=`curl -s "$URL" | \
	grep \<title\> | \
	sed "s/\<title\>\([^<]*\).*/\1/" | \
	awk -F "<>" '{print $2}'`
        echo "[[$URL|$TITLE]]"
done
