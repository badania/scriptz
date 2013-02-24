#!/bin/sh
#Graphical utility to allow setting conky's config file
#Source: https://github.com/nodiscc
#License: MIT
#TODO: allow selecting network interface
#TODO: Create a desktop launcher for the configuration dialog
#TODO: Create a desktop launcher for running the conf directly
#TODO: Use YAD. See https://github.com/nodiscc/rxtx-linux/misc/mockup for ideas
#TODO: how it should work:
#	Display a checkbox list with all .conkyrc files in the config dir
#	When "Start" button is pushed,
#		Create a file listing all enabled config files (eg ~/.conky/config.list)
#		Run all config files. (for i in cat config.list; do conky -c $i; done)
#	When "Stop" pushed, stop
#	When "LOad" pushed, display a file chooser to allow selecting an arbitrary config file
#	Check if the file is a conky config (for example grep update_interval)
#	If it looks like one, ask if the user wants to add it permanently to his config files.
#		If yes, ask for a name, copy the file to the config dir with a .conkyrc extension
#		If no, just run conky with the config file

GLOBALCONFIGFILESPATH="/usr/share/conky/configs"
USERCONFIGFILESPATH="$HOME/.conky"
TITLE="Conky: configuration"

while getopts ":d:" opt; do
	case $opt in
	d)
	  GLOBALCONFIGFILESPATH="$OPTARG"
#	  echo "$OPTARG"
	  ;;
	esac
done

#Check/create config files directory
if [ ! -d $USERCONFIGFILESPATH ]
then
	mkdir -p $USERCONFIGFILESPATH
fi

#Display dialog
AVAILABLEFILES=`find $GLOBALCONFIGFILESPATH -name *.conkyrc`
FILESTODISPLAY=$(for FILE in `echo "$AVAILABLEFILES"`; do basename "$FILE"; done)
SELECTEDFILE=`echo "$FILESTODISPLAY" | xargs zenity --title="$TITLE" --window-icon="/usr/share/icons/Faenza/apps/scalable/gnome-system-monitor.svg" --text "Sélectionnez le fichier de configuration à utiliser" --list --column "Fichier de configuration"`
NEWCONFIG="${GLOBALCONFIGFILESPATH}/${SELECTEDFILE}"

#If no file/invalid file selected, exit
if [ ! -f $NEWCONFIG ]
	then exit 1
fi

#Create symlink to config file (replace if it exists)
if [ -e ~/.conkyrc ]
	then zenity --question --title="$TITLE" --text "Etes vous sûr de vouloir remplacer votre fichier de configuration actuel?"
	if [ "$?" = "0" ]
		then rm ~/.conkyrc
		ln -s $NEWCONFIG ~/.conkyrc
		else exit 1
	fi
	else rm ~/.conkyrc
	ln -s $NEWCONFIG ~/.conkyrc
fi

#Restart conky
killall conky
conky


