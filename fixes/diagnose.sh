#!/bin/bash
#TODO: zenity interface if available

DIAGFILE="$HOME/rapport-`date +%F`.txt"
USERHOME="$HOME"

echo "
System diagnostic script 0.9
Rxtx Linux project
nodiscc@gmail.com" | tee $DIAGFILE




echo "
Entrez votre mot de passe administrateur" | tee -a $DIAGFILE
sudo true #enable sudo

echo "
Get date" | tee -a $DIAGFILE
date | tee -a $DIAGFILE

echo "
Get current user" | tee -a $DIAGFILE
whoami | tee -a $DIAGFILE #check for user

echo "
Get system uname" | tee -a $DIAGFILE
uname -a | tee -a $DIAGFILE #get kernel version, uptime

echo "
List of loaded modules" | tee -a $DIAGFILE
lsmod | tee -a $DIAGFILE #list modules

echo "
List of unpurged packages" | tee -a $DIAGFILE
aptitude search ~c | tee -a $DIAGFILE #Select packages that were removed but not purged.

echo "
List of automatically installed packages" | tee -a $DIAGFILE
aptitude search ~M | tee -a $DIAGFILE #Select automatically installed packages

echo "
List of manually installed packages" | tee -a $DIAGFILE
aptitude search '!~M ~i' | tee -a $DIAGFILE #Select manually installed packages

echo "
APT Policy" | tee -a $DIAGFILE
apt-cache policy | tee -a $DIAGFILE #affiche la priorité de chaque source

echo "
List of running processes" | tee -a $DIAGFILE
ps aux | tee -a $DIAGFILE #get running processes

echo "
Installing rcconf"
sudo aptitude -Ry install rcconf 

echo "
List of services and status" | tee -a $DIAGFILE
sudo rcconf --list | tee -a $DIAGFILE #ge t services status

echo "
Liste des dossiers utilisateur à déplacer" | tee -a $DIAGFILE
cd $HOME
ls tee -a $DIAGFILE #get user directory contents

echo "
Network Manager state" | tee -a $DIAGFILE
nm-tool | tee -a $DIAGFILE

echo "
Disk usage" | tee -a $DIAGFILE
df -h | tee -a $DIAGFILE

echo "
List of PCI devices" | tee -a $DIAGFILE
lspci -k | tee -a $DIAGFILE

echo "
List of USB devices" | tee -a $DIAGFILE
lsusb | tee -a $DIAGFILE

echo "
List of unpurged packages" | tee -a $DIAGFILE
aptitude search ~g #Select packages that are not required by any manually installed package

echo "
Terminé. Le rapport a été sauvegardé dans $DIAGFILE" | tee -a $DIAGFILE
