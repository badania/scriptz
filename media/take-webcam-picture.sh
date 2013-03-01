#!/bin/bash
# source: http://www.commandlinefu.com/commands/view/11774/press-enter-and-take-a-webcam-picture.
read && ffmpeg -y -r 1 -t 3 -f video4linux2 -vframes 1 -s sxga -i /dev/video0 ~/webcam-$(date +%m_%d_%Y_%H_%M).jpeg
