#!/usr/bin/env python
#Text-to-speech using Google Translate API
#Usage: gsay.py "your text here"
#needs python-requests python-urllib

import sys
import requests
import urllib
import tempfile
import commands

tosay = sys.argv[1].split()
temp_file = tempfile.NamedTemporaryFile()

def download(string):
    url = "http://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=" + urllib.quote_plus(string)
    temp_file.write(requests.get(url).content) #mpeg can just be appended

s = ''
for x in tosay:
    if len(s + x) > 99:
        download(s)
        s = x
    else:
        s += ' ' + x
download(s)

commands.getoutput('mplayer ' + temp_file.name)
