#!/bin/bash
#TODO: everything.
#I did not find how to do this. For now, use http://pgl.yoyo.org/urlex/
#Best luck I had:
FILE="$1"
grep -o 'http.*"' "$FILE"
