#!/bin/bash
#Thanks to http://www.unix.com/unix-dummies-questions-answers/87375-how-count-occurences-specific-word-file-bash-shell.html
tr -s ' ' '\n' < @1 | grep -c '@2'
