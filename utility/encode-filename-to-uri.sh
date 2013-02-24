#!/bin/bash
# Source: http://stackoverflow.com/questions/296536/urlencode-from-a-bash-script
# On debian, needs liburi-encode-perl
URI="file://$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "`readlink -f $1`" |sed 's/\%2F/\//g')"
echo $URI
