#!/bin/bash
#Source: http://www.reddit.com/r/commandline/comments/1kubou/some_help_naming_your_web_site/
grep '[^aeiou]er$' /usr/share/dict/words | shuf -n 1 | sed -r -e 's~er$~r~' -e 's~^(\w)~\u\1~'
