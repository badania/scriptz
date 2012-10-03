#!/bin/bash
#Fetches a useragent list from http://www.useragentstring.com/pages/useragentstring.php
#And converts the page to plain-text to use with curl, sqlmap...

curl http://www.useragentstring.com/pages/Chrome/ | html2text -width 600 | grep "\ \*\ " | sed 's/\ \ \ \ \*\ //g' | tr "_" " "
