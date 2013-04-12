#!/bin/bash
#Description: Copy some image filenames to your clipboard (using ctrl+c from
#nautilus, for example), and pass them as arguments to this script. It will
#generate dokuwiki links to the images. You just have to upload the images to
#your dokuwiki namespace. Useful for feeding a large number of screenshots in
#a dw page
#Copyright: Rxtx Project <nodiscc@gmail.com>
#License: MIT (http://opensource.org/licenses/MIT)

THUMBNAILSIZE=100
NAMESPACE=":rxtx:"

for IMAGE in $@
do
	PACKAGE=$(basename "$IMAGE")
	echo "{{$NAMESPACE$PACKAGE?direct\&$THUMBNAILSIZE|}}"
done
