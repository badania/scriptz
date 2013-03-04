#!/bin/bash
#Fetches a webpage title
#Source: http://stackoverflow.com/questions/3833088/extract-title-of-a-html-file-using-grep
URL="$1"

wget "$URL" -q -O - | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}'
