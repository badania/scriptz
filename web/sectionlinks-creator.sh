#!/bin/bash
#Create nice images for section links on a homepage, a bit like kvraudio.com does with plugins.
#Some other related ideas:
# * When not hovered, decrease the image brightness.
# * When hovered, transition to normal brightness
# * Have a sliding jQuery color box follow the link hovering.
# * Cool story bro. Do it now.

DESIREDWIDTH=350
DESIREDHEIGHT=150

#Take an approximative screenshot of the region you want with scrot
#It should be at least 350*150px
#If its too narrow, scale it to 350px width
#If its not high enough, scale it to 150px height
#If it has been resized, repeat the 2 previous operations to check
#If it's bigger than 350x150px, take a random 350x150px region of it, and crop it there.
#Add rounded corners
#Display a text input, wait for user to enter some title and validate
#Apply the entered title as watermark with a nice font
#Apply a subtle vignetting filter
#Round the corners
#Save the pic as $title.png with filename sanitization
#???
#profit.
