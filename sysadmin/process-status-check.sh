#!/bin/bash
# Name : service.chk
# URL: http://bash.cyberciti.biz/monitoring/simple-process-checker-script/
# Purpose: A simple process checker. Find out if service is running or not.
# Tested on: Debian and RHEL based system only.
# ----------------------------------------------------------------------------
# Author: nixCraft <http://www.cyberciti.biz>
# Copyright: 2009 nixCraft under GNU GPL v2.0+
# ----------------------------------------------------------------------------
# Last updated: 13/Mar/2013 - Added support for email and other enhancements
# Last updated: 05/Dec/2011 - Added support for binary path check
# ----------------------------------------------------------------------------
 
## Change as per your distro
_pgrep="/usr/bin/pgrep"
_mail="/usr/bin/mail"
 
## Add binary list here
_chklist="/usr/bin/php-cgi /usr/sbin/nginx /usr/sbin/lighttpd /usr/sbin/mysqld /usr/sbin/apache2 /usr/sbin/named /usr/sbin/pgsqld"
 
## yes | no
_sendemail="no"
 
## Add your email id
_email="your@mobile.email.id.example.com"
 
## Do not change below
_failed="false"
_service="Service:"
 
_running() {
local p="${1##*/}"
local s="true"
$_pgrep "${p}" >/dev/null || { s="false"; _failed="true"; _service="${_service} $1,"; }
[[ "$s" == "true" ]] && echo "$1 running" || { echo -n "$1 not running"; [[ ! -f "$1" ]] && echo " [ $1 not found ]" || echo ; }
}
 
## header
echo "Service status on ${HOSTNAME} @ $(date)"
echo "------------------------------------------------------"
 
## Check if your service is running or not
for s in $_chklist
do
_running "$s"
done
 
## Send a quick email update (good for cron jobs) ##
[[ "$_failed" == "true" && "$_sendemail" == "yes" ]] && { _mess="$_service failed on $HOSTNAME @ $(date)";
$_mail -s 'Service not found' "$_email" < "${_mess}";
}
 
