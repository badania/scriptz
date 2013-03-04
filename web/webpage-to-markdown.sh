#!/bin/bash
#fetches a webpage and converts it to markdown
URL="$1"
OUTFILE="$2"
USAGE="USAGE: `basename $0` page_url output_file"

if [ "$1" = "" -o "$2" = "" ]
	then echo "$USAGE"
	exit 1
fi

pandoc -f html -t markdown "$URL" > "$OUTFILE"
