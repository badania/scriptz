#!/bin/bash
#create a nice pdf file from manpages, system help files and such
#status: just started

#define what manpages, files etc. we want
SYSADMIN_COMMANDS="addgroup cd mv cp rm du df rename touch delgroup adduser deluser groupadd groupdel useradd userdel dmsetup taskset insserv rcconf update-rc.d at lastb ls w who wtmp chage chmod chown chroot df dmesg getfacl setfacl install lsof lspci lsusb mkfs ntfsfix proc ps pstree top uptime vmstat signal man xargs faillog mktemp ltrace find locate update-alternatives pgrep bash htop fuser pkill killall atool tar gzip zip unrar 7z zcat zless logrotate ranger mount"

TEXTHANDLING_COMMANDS="awk cat cut grep head tail echo less sed tr wc ascii cmp comm column dirname fmt strings wdiff paste nl split sort shuf tee sponge readlink"

MISC_COMMANDS="apropos inotifywait xclipboard xclip hier watch wmctrl yes pdfimages enscript ps2pdf chm2pdf pdfimages pdftotext pdfunite date xdg-open svn git pv gedit gnupg"

PACKAGEMANAGEMENT_COMMANDS="apt-cache apt-get aptitude dpkg dpkg-divert"

NET_COMMANDS="ssh-keygen ssh iptables iptables-apply iptables-restore iptables-save ufw smb.conf ssh ssh_config sshd sshd_config arpspoof dig ping mtr traceroute netstat nmap ss curl wget rsync wireshark tshark transmission-daemon iceweasel torify" 

MEDIA_COMMANDS="youtube-dl cclive ffmpeg mplayer gimp vlc scrot feh"

TEXT_FILES="/etc/services /proc/filesystems"

HELP_COMMANDS="disown read set jobs bg fg pushd popd alias declare export local trap"

mkdir ~/manpagestopdf/
cd ~/manpagestopdf/

for page in $SYSADMIN_COMMANDS $TEXTHANDLING_COMMANDS $MISC_COMMANDS $PACKAGEMANAGEMENT_COMMANDS $NET_COMMANDS $MEDIA_COMMANDS; do man -t $page | ps2pdf - -> $page.pdf; done

for page in $TEXT_FILES; do enscript -p - $page | ps2pdf - -> `basename $page`.pdf; done

for page in $HELP_COMMANDS; do help $page | enscript -p - | ps2pdf - -> $page.pdf; done


#man -t $COMMAND | ps2pdf - -> $COMMAND.pdf
#enscript to convert text files to ps
#ps2pdf to convert ps files to pdf
#chm2pdf --book or --continuous to convert chm files
#pdfunite to merge pdf files

#How do I create a table of contents? a pdf index?
#apropos -e $command
