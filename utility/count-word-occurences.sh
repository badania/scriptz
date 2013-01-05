#!/bin/bash
#Thanks to http://www.unix.com/unix-dummies-questions-answers/87375-how-count-occurences-specific-word-file-bash-shell.html
#Usage: count-word-occurences.sh "searchterm" file
#Counts number of occurences of "word" in file
tr -s ' ' '\n' < $2 | grep -c "$1"
