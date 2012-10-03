#!/bin/bash
for file in *.svg; do for size in 16 22 24 32 48 64 96; do mkdir $size; rsvg -w $size -h $size $file $size/`basename $file .svg`.png; done; done
