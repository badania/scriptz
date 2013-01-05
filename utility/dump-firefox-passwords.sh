#!/bin/bash
#Description: dump Firefox passwords (stored in signons.sqlite) to stdout.
#Needs nss-passwords.
#License: MIT
#Copyright: Rxtx Project <nodiscc@gmail.com>

array=`for i in {a..z}; do nss-passwords $i; echo -e "\n"; done;`
echo "$array" | sed 's/|//g' | sed 's/ \+/ /g' |sort | uniq
