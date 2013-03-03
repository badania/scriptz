#!/bin/bash
#source: http://www.reddit.com/r/commandline/comments/18yp5b/bash_script_to_update_multiple_blocklists/c8j6v5a
set -e

URLS=(
http://list.iblocklist.com/?list=bt_level1
http://list.iblocklist.com/?list=bt_level2
http://list.iblocklist.com/?list=bt_level3
http://list.iblocklist.com/?list=bt_bogon
)

wget "${URLS[@]}" -O - | gunzip | LC_ALL=C sort -u >"$HOME/.config/transmission/blocklists/extras-$(date +%d-%b-%R).txt"
