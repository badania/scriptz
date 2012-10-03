#!/bin/bash
#Easy WPA Supplicant connection script.
#TODO: let user choose wifi interface from a list
#TODO: let user choose Network from a list
#
#https://rxtx-linux.googlecode.com/
#

echo "Enter WPA Passphrase, Network SSID and Wifi card name"
read mypassphrase myssid interface

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
