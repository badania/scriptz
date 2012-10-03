# firefoxize-starred-items.py
#
# Reads a Google "Reader JSON" file exported from Google Reader and
# outputs an HTML file suitable for importing into Firefox's 
# bookmarks menu. This rescues you if you have been using Google 
# Reader Starred Items as a bookmark file for feeds.
#
# See http://googlereader.blogspot.com/2011/10/new-in-reader-fresh-design-and-google.html
# and, when logged in, http://www.google.com/reader/settings?display=import



import json, time, codecs

InputFile = '/home/mrzorg/starred-items.json'  #download this
OutputFile = '/home/mrzorg/starred-items-bookmarks.html'  #import this

with codecs.open(InputFile, 'r', encoding='utf-8') as f:
    GooglesItems = json.load(f)['items']

FeedURLs = {}
FeedItems = {}

for item in GooglesItems:
    feedTitle = item['origin']['title']
    feedUrl = item['origin']['htmlUrl']
    itemDate =  item['published']
    if item.has_key('title'):
        itemTitle = item['title'].split('\n')[0]
    else:
        itemTitle = feedTitle + ', ' +  time.strftime('%x', time.localtime(itemDate))
    if item.has_key('alternate'):
        itemURL = item['alternate'][0]['href']
    elif item.has_key('enclosure'):
        itemURL = item['enclosure'][0]['href']
    else:
        itemURL = feedURL
    FeedURLs[feedTitle] = feedUrl
    feedItems = FeedItems.setdefault(feedTitle, [])
    feedItems.append((itemTitle, itemURL, itemDate))

with codecs.open(OutputFile, 'w', encoding='utf-8') as b:
    b.write('''<!DOCTYPE NETSCAPE-Bookmark-file-1>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
    <TITLE>Bookmarks</TITLE>
    <H1>Bookmarks Menu</H1>
    <DL><p>\n''')
    b.write('<DT><H2>Google Reader Starred Items</H2>\n\n')
    b.write('<DL><p>\n')
    for feedTitle, feedURL in FeedURLs.items():
        b.write('<DT><H3>%s</H3>\n' % feedTitle)
        b.write('<DL>\n')
        b.write('<DT><A HREF="%s">(%s)</A>\n' % (feedURL, feedTitle))
        for (title, url, date) in FeedItems[feedTitle]:
            b.write('<DT><A HREF="%s" LAST_MODIFIED="%i">%s</A>\n' % (url, date, title))
        b.write('</DL>\n\n')
    b.write('</DL>\n\n\n')
    b.write('</DL><p>\n')
