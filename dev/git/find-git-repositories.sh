#!/bin/bash
#Finds git repositories on the system, eventually update (pull) from remotes
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: Rxtx Project <nodiscc@gmail.com>
#TODO: initialize variables to their defaults !
#TODO: list/check/pull multiple branches (use git branch -v ?)
#TODO: quote DIR variables!
#TODO: display repository name in bold for clarity
#TODO: add a "quiet" option for push/pull operations
#TODO: detect merge conflicts before push/pull
#TODO: display a summary of updated repos (push/pull)

USAGE="USAGE: `basename $0` [OPTION]
    -d /search/path    only search for repositories in /search/path (default ~/)
    -r                 also show remote addresses
    -o                 optimize (git repack && git prune) repositories
    -c                 check for available updates
    -p                 try pushing to remote
    -n                 do not colorize output
    -u                 update (pull) from repositories"

FIND_DIR="$HOME"

RED="\033[00;31m"
GREEN="\033[00;32m"
ENDCOLOR="\033[00m"


while getopts ":d:rcuhpon" opt; do
  case $opt in
    d)
      FIND_DIR="$OPTARG"
      ;;
    r)
      REMOTES="1"
      ;;
    c)
     CHECK="1"
     ;;
    u)
     CHECK="1"
     UPDATE="1"
     ;;
    h)
     echo "$USAGE"
     exit 0
     ;;
    n)
     RED=""
     GREEN=""
     ENDCOLOR=""
     ;;
    p)
     CHECK="1"
     PUSH="1"
     ;;
    o)
     OPTIMIZE="1"
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
else
	FIND_DIR=`readlink -f $FIND_DIR`
fi

#print dir
echo -e "${GREEN}Searching for git repositories in $FIND_DIR ...${ENDCOLOR}" >&2

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
	REMOTE=`grep "url" $DIR/.git/config 2>/dev/null | awk -F " " '{print $3}'`

	if [ "$REMOTES" = "1" ]
	then
		echo "$DIR - $REMOTE"
	else
		echo $DIR
	fi

	if [ "$CHECK" = "1" ]
	then
		cd $DIR
		git remote update &>/dev/null
		git fetch &>/dev/null
		if [[ `git status | egrep "Your branch is ahead"` != "" ]]
			then echo -e "${RED}Not up to date (do a git push)${ENDCOLOR}";
			if [ "$PUSH"="1" ]; then echo -e "${GREEN}Pushing to remote...${ENDCOLOR}"; git push; fi
		elif [[ `git status | egrep "Untracked files"` != "" ]]
			then echo -e "${RED}Not up to date (untracked files)${ENDCOLOR}"
		elif [[ `git status | egrep "Your branch is behind"` != "" ]]
			then echo -e "${RED}Not up to date (do a git pull)${ENDCOLOR}"
			if [ "$UPDATE"="1" ]; then echo -e "${GREEN}Pulling from remote...${ENDCOLOR}"; git pull; fi
		elif [[ `git status | egrep "not staged for commit"` != "" ]]
			then echo -e "${RED}Not up to date (unstaged changes)${ENDCOLOR}"
		fi
	fi

	if [ "$OPTIMIZE" = "1" ]
	then
		cd $DIR
		echo -e "${GREEN}Optimizing repository...${ENDCOLOR}"
		git repack && git prune
	fi
done
