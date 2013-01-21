#!/usr/bin/python

# import the libraries that we need
from httplib import HTTP
import re
import urllib
import sys
import os

#
#
# method which given a page and a request, it will get the raw html
#
def get_page(url, request):
    html_page = urllib.urlopen( 'http://' + url + request )
    return html_page.read()

#
#
# method which given some raw html code, 
# will download all images from that page
#
def get_page_images(html):

	# define our two patterns to match our images on
    pattern = re.compile('img src="[^"]*')
    pattern2 = re.compile('[^"]*$')

	# find only the strings which match our first pattern
    iterator = pattern.finditer(html)

	# loop through our results, and get each image
    for match in iterator:
    	
    	# get the individual match
        parsed_html = match.group()
        # remove the img src=" part of the string
        image_url = pattern2.findall( parsed_html )[0]
    	
    	# open the 
        image_file = urllib.urlopen( image_url )
        image_file_name = image_url.split("/")[3]
    
        output = open( image_file_name,'wb' )
        output.write( image_file.read() )
        output.close()

#
#
# Methods defined, now lets run our code!
#

# get the name of the tumblr site to download
tumblr_name = sys.argv[1]

# set the defualt number of extra pages to get
extra_pages = 0

# if they have provided a number of pages, we should get that many
if len( sys.argv ) > 2:
    extra_pages = int( sys.argv[2] )

# check to see if a folder for this tumblr site exits
if not os.path.isdir( tumblr_name ):
    # if it does not, make one
    os.mkdir( tumblr_name )

# move into the new directory
os.chdir( tumblr_name )

# get the first page no matter what
html = get_page( tumblr_name + '.tumblr.com', '' )
get_page_images( html )

# then loop through the extra pages, and get the rest of the images
for x in range( 2, ( extra_pages + 1 ) ):
    html = get_page( tumblr_name + '.tumblr.com', '/page/' + str( x ) )
    get_page_images( html )

# done
exit