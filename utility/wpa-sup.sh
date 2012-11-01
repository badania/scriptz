#!/bin/bash
#Easy WPA Supplicant connection script.
#TODO: let user choose wifi interface from a list
#TODO: let user choose Network from a list

echo "Enter WPA Passphrase"
read mypassphrase

echo "Enter network name (ESSID)"
read myssid

echo "Enter wifi card name (leave blank for default: wlan0)"
read interface

if [ "$interface" = "" ]
	then interface="wlan0"
fi


echo "Calculating PSK...."
mypsk=`wpa_passphrase $mypassphrase $myssid | sed -n 4p | sed -e 's/\tpsk=//g'`

echo "creating /etc/wpa_supplicant.conf"
sudo echo 'ctrl_interface=/var/run/wpa_supplicant
#ap_scan=2

network={
       ssid=\"$myssid\"
       scan_ssid=1
       proto=WPA RSN
       key_mgmt=WPA-PSK
       pairwise=CCMP TKIP
       group=CCMP TKIP
       psk=$mypsk
}
' > /etc/wpa_supplicant.conf

echo "Trying to connect..."
sudo wpa_supplicant -Bw -Dwext -i $interface -c/etc/wpa_supplicant.conf
