#!/bin/bash
#This parses a text file containing youtube links and generates a list of
#dokuwiki-formatted links to the Youtube pages with video thumbnails.
#DEPRECATED, CAUSES HORRIBLE LOADING TIMES ON THE PAGE

files="$@"
for ID in `cat $files | sed 's/.*v=//' | cut -f 1 -d "&"`; do echo "[[https://www.youtube.com/watch?v=$ID|{{http://img.youtube.com/vi/$ID/0.jpg?250}}]]" ; done
