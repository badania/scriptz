#!/bin/sh
#create a 200px thumb for each png image here, write it in a thumbs/ subdir.

mkdir thumbs
for image in *.png; do
if [ ! -e thumbs/"$image"_th.png ] #do not re-create it if it exists
	then convert -resize 200x "$image" thumbs/`basename "$image" .png`_th.png
fi
done
