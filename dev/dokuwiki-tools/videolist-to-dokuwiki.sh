#!/bin/bash
#This script lists webm and flv files in a directory, and creates a list of links formatted for
#dokuwiki, assuming the files are youtube videos extracted witch clive --filename-format=%h_%i-%t.%s
#The output can be pasted to a dokuwiki page and the videos will be linked.
#The script displays a warning if there are files that do not match the naming pattern.

ls youtube*.webm youtube*.flv| \
sed 's/youtube_/https:\/\/youtube.com\/watch?v=/' | \
awk '{print substr($0,0,40)"|"substr($0,41)}' | \
sed 's/.webm//' | while read item; do echo "[[$item]]\\\\"; done

#CHECK IF FILES WERE FORGOTTEN
TOTALFILECOUNT=`ls | wc -l`
VIDEOCOUNT=`ls *.webm *.flv| wc -l`

if [ "$TOTALFILECOUNT" -ne "$VIDEOCOUNT" ]
then
	echo -e "\n\nWARNING: SOME FILE WERE NOT LISTED">&2
	ls | egrep -v "*.flv|*.webm">&2
	ls | egrep -v "youtube*">&2
	echo -e "WARNING: SOME FILES WERE NOT LISTED\n">&2
fi
