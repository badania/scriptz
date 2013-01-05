#!/bin/bash
#finds wikipedia URLs in Scrapbook's index files
#License: MIT (http://opensource.org/licenses/MIT)
#Copyright: Rxtx Proejct <nodiscc@gmail.com>
#TODO: allow changing keyword, allow changing source rdf, output to file
grep --color=always wikipedia.org scrapbook.rdf  | awk -F "=" '{print $2 }' | sed 's/\/>//g' | tr "\"" "\0" | sort
