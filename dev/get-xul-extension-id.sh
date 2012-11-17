#!/bin/bash
# Retrieve the extension id for an addon from its install.rdf
EXID=`unzip -qc $1 install.rdf | xmlstarlet sel \
    -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
    -N em=http://www.mozilla.org/2004/em-rdf# \
    -t -v \
    "//rdf:Description[@about='urn:mozilla:install-manifest']/em:id"`

unzip $1 -d ~/FFaddons/"$EXID"
