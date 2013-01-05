#!/bin/bash
#Description: ask before forcing optical disc drive ejection
#Licence: MIT
#Copyright: Rxtx Project <nodiscc@gmail.com>

zenity --question --title "Ejection du CD/DVD" --text "Forcer l'ouverture du tiroir? Le volume 
va être démonté de force. Les opérations
en cours sur le CD vont échouer."

if [ $? = 0 ]
then
	pkexec umount -fl /dev/cdrom
	sleep 1
	eject
else
	exit 0
fi

