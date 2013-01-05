#!/bin/bash
#script to build ALSA firmware
#works with E-MU 0404 soundcard
#from http://wiki.debian.org/snd-emu10k1
#https://rxtx-linux.googlecode.com/

#Check for root privileges
if [ `whoami` = "root" ]; then
	true
	else echo "This script must be run as root"; exit 1
fi

#Install Build-essential
aptitude update &&
aptitude -Ry install build-essential &&

#get and uncompress the latest alsa firmwares
mkdir -p /tmp/alsafirmware/ &&
cd /tmp/alsafirmware/ &&
wget ftp://ftp.alsa-project.org/pub/firmware/alsa-firmware-1.0.24.1.tar.bz2 &&
tar xvf alsa-firmware-1.0.24.1.tar.bz2 &&

#Compile firmwares
cd alsa-firmware-1.0.24.1 &&
./configure &&
cd emu && make &&

#Install firmwares and reload E-MU kernel module
mkdir -p /usr/local/lib/firmware/emu &&
cp *fw /usr/local/lib/firmware/emu
rmmod snd-emu10k1-synth snd-emu10k1 ; modprobe snd-emu10k1 &&

#Remove temporary build dir
cd / &&
rm -r /tmp/alsafirmware &&


#Set E-MU card as default
touch /etc/modprobe.d/99-alsa-default-emu.conf &&
echo "options snd-emu10k1 index=0" > /etc/modprobe.d/99-alsa-default-emu.conf &&

#Reload sound system
alsa force-reload
