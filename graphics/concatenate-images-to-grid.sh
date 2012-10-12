#!/bin/bash
#concatenates images to a single grid of images

N=11 #number of lines
M=3 #number of columns
OUTFILE=joined.png

montage +frame +shadow +label -tile $Nx$M -geometry +0+0 $@ $OUTFILE
