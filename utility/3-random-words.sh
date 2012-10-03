#!/bin/bash
function checkword() {
sed `perl -e "print int rand(99999)"`"q;d" /usr/share/hunspell/fr_FR.dic >> checkword
}

while [ `cat checkword 2>/dev/null | wc -l` -ne "3" ]; do checkword; done
cat checkword
rm checkword
