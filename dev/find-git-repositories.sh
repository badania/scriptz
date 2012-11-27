#!/bin/bash
#finds git repositories on the system
#TODO: allow selecting base directory
FIND_DIR="/home/"

#specify directory to look up with -d
while getopts ":d:r" opt; do
  case $opt in
    d)
      FIND_DIR="$OPTARG" >&2
      ;;
    r)
      REMOTES="1" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Usage: -$OPTARG must have an argument" >&2
      exit 1
      ;;
  esac
done

#check if directory is searchable
if [ ! -d $FIND_DIR ]
then
	echo "$FIND_DIR does not exist or is not a valid directory"
	exit 1
fi

#print dir
echo "Searching for git repositories in $FIND_DIR ..." >&2

#create array
REPOS=()

#find repos
for i in `find -L $FIND_DIR -name ".git" -type d 2>/dev/null`
do
	REPOS+=(`dirname "$i"`)
done

#print repos list
for DIR in ${REPOS[@]}
do
	REMOTE=`echo "- "; grep "url" $DIR/.git/config 2>/dev/null | awk -F " " '{print $3}'`
	if [ "$REMOTES" = "1" ]
	then
		echo $DIR $REMOTE
	else
		echo $DIR
	fi
done

echo $REMOTES
