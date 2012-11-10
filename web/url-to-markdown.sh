#!/bin/bash
#fetches a webpage and converts it to markdown
URL="$1"
OUTFILE="$2"

pandoc -f html -t markdown "$URL" > "$OUTFILE"
