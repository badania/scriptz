#!/bin/bash
#Create a link to an URL using dokuwiki syntax. (Using page title as the link text)
#License: MIT (http://opensource.org/licenses/MIT)


for RESURL in $@
        do
        RESOURCETITLE=`wget "$RESURL" -q -O - | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}'`
        echo "  * [[$RESURL|$RESOURCETITLE]]"
done
