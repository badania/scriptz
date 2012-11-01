#!/bin/bash
#Lists all ubuntu ppas in APT sources lists
#from http://www.ubuntuvibes.com/2012/10/list-all-ubuntu-ppas-with-single-command.html
grep -RoPish "ppa.launchpad.net/[^/]+/[^/ ]+" /etc/apt | sort -u | sed -r 's/\.[^/]+\//:/'
