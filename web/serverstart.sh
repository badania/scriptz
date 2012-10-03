#!/bin/bash

checkandrunservices() {
if [ ! -e /var/run/mysqld/mysqld.pid ]; then
	sudo service mysql start;
	else stopserver;
fi

if [ ! -e /var/run/apache2.pid ]; then
	sudo service apache2 start;
	else stopserver;
fi

if [ ! -e /var/run/filetea.pid ]; then
	sudo service filetea start;
	else stopserver
fi

echo -e "\n Do you want to start monitoring? [Y/...] "
read -n 1 ANSWER
echo -e "\n"
if [ "$ANSWER" == "Y" ]
then
	startmonitor
else
	exit 0
fi


echo -e "\n Server started."
}


stopserver() {
echo -en "\n Server seems to be running. Stop it ? [Y/...] "
read -n 1 ANSWER
echo -en "\n"
if [ $ANSWER = "Y" ]
then
	sudo service apache2 stop;
	sudo service mysql stop;
	sudo service filetea stop;
	killall logstalgia;
	sudo killall netstat;
	exit 0
else 
	echo -en "\n Do you want to start monitoring? [Y/...] "
	read -n 1 ANSWER
	echo -en "\n"
	if [ $ANSWER = "Y" ]
	then
		startmonitor
	else
		exit 0
	fi
fi
}


#a better monitor? netstat -lntp
startmonitor() {
killall logstalgia
sudo killall netstat
tail -f /var/log/filetea/access.log /var/log/apache2/access.log | logstalgia -400x300 --sync --font-size 10 &
#while true; do clear; sudo netstat -anpt --inet | egrep "filetea|apache|sshd|sqld"; sleep 3; done
while true; do clear; sudo netstat -anpt --inet | egrep "0.0.0.0|apache2|sshd|cupsd|:9050|polipo|mysqld|LISTEN"; sleep 3; done
}

checkandrunservices
