#!/bin/bash
#Description: takes items from a list (1st argument) and searches for these items
#in other filese (arguments starting from 2nd). If an item is not found in the second file
#output, an error.
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: Rxtx Project <nodiscc@gmail.com>

USAGE="Usage: `basename $0` [item_list_file] [files_to_search in]"
ITEM_LIST="$1"
PARAMS=($@)
FILE_TO_SEARCH="${PARAMS[@]:1}"

if [ "$1" = "" -o "$1" = "-h" -o "$2" = "" ]
then
	echo "$USAGE"
	exit 1
fi

for item in `cat $ITEM_LIST`
do
	grep -q --color=always "$item" $FILE_TO_SEARCH
	if [ $? != 0 ]
	then
		echo -e "\033[00;31m$item\033[00m not found"
	fi
done
