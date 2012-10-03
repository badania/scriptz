#!/bin/bash
#
# By Sirupsen @ http://sirupsen.dk
# Modified for rxtx
#
# Description: Very simple script to make you
# select a region of your screen, which will be captured, and
# then uploaded. The URL will then be injected into your clipboard.
#
# Dependencies:
#
# Scrot
# Comment: Scrot is what takes the actual screenshot.
#
# Xclip
# Comment: Xclip is what makes the script able to inject the direct url
# into your clipboard.
#
# libnotify-bin
# Comment: Will notify you whenever the direct URL is in the clipboard
#

function uploadImage {
  curl -s -F "image=@$1" -F "key=486690f872c678126a2c09a9e196ce1b" http://imgur.com/api/upload.xml | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*"
}

capturefile="/tmp/screenshot_`date +%s`.png"
scrot -s "$capturefile" 
uploadImage "$capturefile" | xclip -selection c
rm "$capturefile"
notify-send -i gnome-screenshot "Screenshot done" "Image uploaded to `xclip -selection c -o`, address copied to clipboard"
