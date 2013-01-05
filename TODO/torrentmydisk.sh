#!/bin/bash
#list all folders
ALLFOLDERS=`ls -Q */`

#for all folders, check if they contain mp3, flac or ogg
#
ls
#if not, ignore them

#if yes
	#then calculate average bitrate
	#check if 
#for each folder containing mp3s, create a torrent

buildtorrent \
--announce=udp://tracker.openbittorrent.com:80
--name=`cat @1 | sed 's/ /_/g'`_$AVGBITRATE.torrent


#anotther idea
mediainfo 101\ Prelude.mp3 | grep "Format" | egrep -v "version|profile"|uniq
mediainfo 101\ Prelude.mp3 | grep "Bit rate" | egrep -v "mode" | awk '{print $4}'
