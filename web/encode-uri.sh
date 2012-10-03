#!/bin/bash
#This command line percent-encodes strings, even binary data.
#Thanks to https://andy.wordpress.com/2008/09/17/urlencode-in-bash-with-perl/

ENCODED=$(echo -n "$@" | \
perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg');
echo $ENCODED
