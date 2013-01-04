#!/bin/bash
#Description: parses a netscape/mozilla/delicious HTML bookmark file for links that cclive(1) can download, allows selecting a tag, then downloads every media corresponding to that tag.
#License: GPLv3
#Copyright: (c) 2012 Rxtx Project <nodiscc@gmail.com>
#TODO: Allow not only downloading media, but also text/html files like Scrapbook does
#TODO: report errors
#TODO: test if we are in a pts/tty. If not, use zenity as a frontend (if [ `tty` != "*/dev/*" ......)
#TODO: send title as detected by quvi (%t) to mplayer (-title) or vlc (--meta-title)

#TODO SOURCE="" #can be any of Webpage, Netscape/Firefox/Delicious bookmark format (supports tags), Simple list
#TODO QUALITY="" #can be any of low/medium/high
USAGE="USAGE: `basename $0` [download|stream] /path/to/bookmarks/file.html [/path/to/download/dir/] [tag]"
ACTION="$1"
BOOKMARKFILE="$2"
DEST_DIR="$3"
TAGS="$4"
SUPPORTEDSITES=`cclive --support | tr "\n" "\|" | awk 'sub(".$", "")'`
#PLAYCOMMAND="vlc --playlist-enqueue %u &"
PLAYCOMMAND="mplayer %u -title %t"
#PLAYCOMMAND="vlc --playlist-enqueue %u"
RED="\033[00;31m"
GREEN="\033[00;32m"
ENDCOLOR="\033[00m"

#Check parameters
if [ "$1" = "" ]
	then echo "$USAGE"
	exit 1
fi

if [ ! -f "$BOOKMARKFILE" ]
	then echo -e "${RED}Error: you did not specify a bookmarks.html file, or it is not valid${ENDCOLOR}"
	echo "$USAGE"
	exit 1
fi


function SelectTags() {
if [ "$TAGS" = "" ]
	then echo -e \
"What do you want to download/stream?
${GREEN}[1]${ENDCOLOR} music
${GREEN}[2]${ENDCOLOR} videos
${GREEN}[3]${ENDCOLOR} other (free keyword)"
read TAGSELECTION
case $TAGSELECTION in
	"1")
	  TAGS="music"
	  ;;
	"2")
	  TAGS="video"
	  ;;
	"3")
	  echo "Please enter a keyword to look for in the bookmarks:"
	  read TAGS
	  ;;
	"")
	  echo "You entered an empty keyword. Aborting"
	  exit 1
	  ;;
esac
fi
}

function Parse() {
egrep -w "$SUPPORTEDSITES" $BOOKMARKFILE | egrep "TAGS=.*$TAGS.*" | awk -F "\"" '{print $2}'
}


function Download() {
if [ ! -d "$DEST_DIR" ]
	then echo -e "${RED}Error: you did not specify a destination directory, or it is not valid${ENDCOLOR}"
	echo "$USAGE"
	exit 1
fi

SelectTags
cd "$DEST_DIR"
echo -e "Downloading ${GREEN}$TAGS${ENDCOLOR} related items from ${GREEN}$BOOKMARKFILE${ENDCOLOR}. Saving to ${GREEN}$DEST_DIR${ENDCOLOR}"
Parse | xargs cclive --continue
}


function Stream() {
SelectTags
echo -e "Streaming ${GREEN}$TAGS${ENDCOLOR} related items from ${GREEN}$BOOKMARKFILE${ENDCOLOR}."
Parse | xargs quvi --exec="$PLAYCOMMAND"
}

case "$ACTION" in
	"download")
	Download
	;;
	"stream")
	Stream
	;;
	*)
	echo "$USAGE"
	echo "Action $ACTION is not a valid action"
	;;
esac
