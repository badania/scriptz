#!/bin/bash
#Retrieve a local copy of your accounts data from several web services.
#Dependencies: googlecl, curl, python-jsonpipe, xmlstarlet
#and of course grep, awk, cut, sed, coreutils...

#Global variables
export MODULES_PATH=`dirname $0`

#Usernames
export GITHUB_USER=""
export DEVIANTART_USER=""
export GOOGLE_USER=""
export VIMEO_USER=""
export LASTFM_USER=""

export IDENTICA_USER=""
export REDDIT_USER="badsuperblock"
export GROOVESHARK_USER=""

#Passwords and keys
export LASTFM_APIKEY="9b6009eca365ded3a03c2b9673d54eb9"
export REDDIT_PASSWD="ahWoChaemij1Uba"


while getopts ":m:l" opt; do
  case $opt in
    m)
      bash "$MODULES_PATH"/"$OPTARG".module
      ;;
	l) #print available modules
	  find "$MODULES_PATH" -name "*.module" -exec basename '{}' \;
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


###TODO: put the variables (usernames;passwords) in a .config file
###TODO: fail if a requested module has no username/password set for it
###TODO: allow selecting modules with `-m modulename.module -m another.module`, default to all modules
###TODO: Interactive mode: ask for services to backup, prompt for username/passwords
###TODO: clear variables and tempfiles on exit