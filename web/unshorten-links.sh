#!/bin/bash
#Unshortens a link.
LONGURL=`curl -s http://www.unshorten.it/api1.0.php?shortURL=$1`
#If there was an error, return the original url
if [[  "$LONGURL" == *error* ]]
then
	echo $1
#If unshortened url does not contain http, something went wrong, return the
#original url...
elif [[ ! "$LONGURL" == *http* ]]
then
	echo $1
else
	echo $LONGURL
fi
