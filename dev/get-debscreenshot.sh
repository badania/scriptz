#!/bin/bash
#For each specified package, fetches a large screenshot from s.d.n and places it in a subdir
#TODO: create thumbnails, report errors


for PACKAGE in pybackpack osmo evolution icedove iceweasel owncloud filezilla synapse volumeicon-alsa xpad xfce4-power-manager gtk-redshift network-manager-gnome tint2 gnome-terminal nautilus audacious liferea pidgin iceweasel transmission-gtk file-roller mousepad gedit eog lxappearance bleachbit eog gnome-control-center pdfmod gnome-system-monitor evince icedove soundjuicer brasero gnome-screenshot gnome-activity-journal
do
#	mkdir $PACKAGE
#	cd $PACKAGE
	for SCREENSHOT in `curl -s -A "Mozilla/4.0, debscreenshotgrabber" -f http://screenshots.debian.net/package/$PACKAGE | grep "large.png" | cut -f 4 -d "\""`
	do FILENAME=$PACKAGE-`basename $SCREENSHOT`
		if [ -f $FILENAME ]
		then echo "File $FILENAME already exists, skipping..."
		else wget -U "Mozilla/4.0, debscreenshotgrabber" -nv -O $FILENAME http://screenshots.debian.net/$SCREENSHOT; sleep 3;
		fi
	done
#	cd ..
done

