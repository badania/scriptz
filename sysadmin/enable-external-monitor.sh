#!/bin/bash
#SOurce: http://blog.rolinh.ch/linux/comment-appliquer-une-configuration-decran-specifique-automatiquement-lorsquun-ecran-externe-est-detecte/
# apply dual-screen configuration when VGA is connected
xrandr | grep "VGA1 connected"
if [ $? -eq 0 ]; then
        xrandr --output LVDS1 --mode 1600x900 --pos 0x0 --rotate normal --output VGA1 --mode 1280x1024 --pos 1600x0 --rotate normal
fi

