#!/bin/bash
#Description: parses a netscape/mozilla/delicious HTML bookmark file for links that cclive(1) can download, allows selecting a tag, then downloads every media corresponding to that tag.
#License: GPLv3
#Copyright: (c) 2012 Rxtx Project <nodiscc@gmail.com>
#TODO: Allow not only downloading media, but also text/html files like Scrapbook does
#TODO: report errors
#TODO: test if we are in a pts/tty. If not, use zenity as a frontend (if [ `tty` != "*/dev/*" ......)
#TODO: send title as detected by quvi (%t) to mplayer (-title) or vlc (--meta-title)

#Initialize tags
TAGS=""

SOURCE="bookmarks" #can be an URL (use "url"), a plain text list (use "bookmarks") or a Netscape/Firefox/Delicious bookmark format - supports tags (use "bookmarks" too).
#TODO: auto detect urls in $2
USAGE="USAGE: `basename $0` [downloadmedia|stream|createplaylist|getlinks] /path/to/bookmarks/file.html [/path/to/download/dir/] [tag]"
ACTION="$1"
BOOKMARKFILE="$2"
DESTDIR="$3"
TAGS="$4" #TODO: supoort for mutliple tags
QUALITY="best" #Media download/stream quality. Can be "default" or "best", see `man cclive`
SUPPORTEDSITES=`cclive --support | tr "\n" "\|" | awk 'sub(".$", "")'`
PLAYCOMMAND="mplayer %u -title %t"
#PLAYCOMMAND="vlc --playlist-enqueue %u"

RED="\033[00;31m"
GREEN="\033[00;32m"
ENDCOLOR="\033[00m"



#Check parameters
##Empty parameters
if [ "$1" = "" ]
	then echo "$USAGE"
	exit 1
fi

###Check bookmarks file
if [ "$SOURCE" = "bookmarks" ] && [ ! -f "$BOOKMARKFILE" ]
	then echo -e "${RED}Error: you did not specify a bookmarks.html file, or it is not valid${ENDCOLOR}"
	echo "$USAGE"
	exit 1
fi

##Check quality parameter
if [ "$ACTION" = "downloadmedia" ] && [ "$QUALITY" = "best" ]
	then QUVIARGS="-f best"
elif [ "$ACTION" = "downloadmedia" ] && [ "$QUALITY" = "default" ]
	then QUVIARGS="-f default"
elif [ "$ACTION" = "downloadmedia" ]
	then echo -e "${RED}Error: $QUALITY is not a supported format option. Set the QUALITY parameter to 'best' or 'default'.${ENDCOLOR}"
fi

##Check destination directory
if [ "$ACTION" = "downloadmedia" -o "$ACTION" = "getlinks" ] && [ ! -d "$DESTDIR" ]
	then echo -e "${RED}Error: you did not specify a destination directory, or it is not valid${ENDCOLOR}"
	echo "$USAGE"
	exit 1
fi


#Functions
##Tag Selection
function SelectTags() {
if [ "$SOURCE" = "bookmarks" ] && [ "$TAGS" = "" ]
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

##Bookmark file parsing (dirty)
function Parse() {
###Check file type
HEADER=`head -n 1 "$BOOKMARKFILE" | grep "DOCTYPE" `
if [ "$HEADER" = ""  ]
	then LISTFORMAT="plain"
	else LISTFORMAT="netscape"
fi

###Don't bother with tags if not in a HTML Bookmarks file
if [ "$LISTFORMAT" = "netscape" ]
	then egrep -w "$SUPPORTEDSITES" $BOOKMARKFILE | egrep "TAGS=.*$TAGS.*" | awk -F "\"" '{print $2}'
	else egrep -w "$SUPPORTEDSITES" $BOOKMARKFILE | awk -F "\"" '{print $2}'
fi
}

##Get links in file
function GetLinks() {
SelectTags
DESTFILE="$DESTDIR/links-`date +%F-%T`"
egrep "TAGS=.*$TAGS.*" "$BOOKMARKFILE" | awk -F "\"" '{print $2}' > "$DESTFILE"
echo -e "${RED}Error: not yet implemented${ENDCOLOR}"
}

##Media Download
function Download() {
SelectTags
cd "$DESTDIR"
echo -e "Downloading ${GREEN}$TAGS${ENDCOLOR} related items from ${GREEN}$BOOKMARKFILE${ENDCOLOR}. Saving to ${GREEN}$DESTDIR${ENDCOLOR}"
Parse | xargs cclive --continue
}

##Media streaming
function Stream() {
SelectTags
echo -e "Streaming ${GREEN}$TAGS${ENDCOLOR} related items from ${GREEN}$BOOKMARKFILE${ENDCOLOR}."
Parse | xargs quvi --exec="$PLAYCOMMAND"
}

##Playlist creation
function CreatePlaylist() {
echo -e "${RED}Error: not yet implemented${ENDCOLOR}"
}


case "$ACTION" in
	"downloadmedia")
	Download
	;;
	"stream")
	Stream
	;;
	"getlinks")
	GetLinks
	;;
	"createplayslist")
	CreatePlaylist
	;;
	*)
	echo "$USAGE"
	echo "Action $ACTION is not a valid action"
	;;
esac
