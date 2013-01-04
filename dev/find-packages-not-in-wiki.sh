#!/bin/bash
#Description: Look for packages that are referenced in rxtx.list.chroot , but not in the wiki.
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: Rxtx Project <nodiscc@gmail.com>

USAGE="USAGE: `basename $0` /path/to/package/lists/ /path/to/wiki/pages/ [wiki_pages_to_exclude]"
PACKAGELISTSDIR="$1"
WIKIPATH="$2"
EXCLUDE_PATTERN=""

if [ "$3" != "" ]
	then EXCLUDE_PATTERN="--exclude=\"$3\""
fi

if [ "$1" = "" ] || [ "$2" = "" ]
	then echo "$USAGE"
	exit 1
fi

echo $EXCLUDE_PATTERN

############
for PATTERN in `cat $PACKAGELISTSDIR/rxtx*`
do
	if grep -rq "$PATTERN" "$WIKIPATH"
	then true
	else echo "$PATTERN not found"
	fi
done
