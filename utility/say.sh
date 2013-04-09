#!/bin/bash
##Source: http://www.commandlinefu.com/commands/view/9629
##Optional: pass a language code like:
#'say -fr bonjour monsieur; say -en hello sir'

if [[ "${1}" =~ -[a-z]{2} ]]
then
	lang=${1#-}
	text="${*#$1}"
else
	lang=${LANG%_*}
	text="$*"
fi

mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null ; 
