#!/bin/bash
#takes items from a list ($1) and searches these items in a second file ($2)
#If an item is not found in the second file, output an error
ITEM_LIST="$1"
FILE_TO_SEARCH="$2"

for item in `cat $ITEM_LIST`
do
	grep -q --color=always "$item" $FILE_TO_SEARCH
	if [ $? != 0 ]
	then
		echo -e "\033[00;31m$item\033[00m not found"
	fi
done
