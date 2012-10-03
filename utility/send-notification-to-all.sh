#!/bin/bash
#Send a desktop notification to all logged in users.
#Found at http://unix.stackexchange.com/questions/2881/

echo -e "Enter your message :\n"
read MESSAGE
echo "$MESSAGE"
who | \
awk -v message="$MESSAGE" '/\(:[0-9]+\)/ {gsub("[:|(|)]","");print "DISPLAY=:"$5 " pkexec --user " $1 " notify-send \"message\""}' | bash
