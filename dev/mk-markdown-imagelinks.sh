#!/bin/bash
#Description: Take image files as parameters, generate a thumbnail for each one in thumbs/, and print a markdown link showing the thumbnail and pointing to the image.
#License: MIT http://opensource.org/licenses/MIT
#Source: https://github.com/nodiscc/scriptz

THUMBNAIL_SIZE="200"
IMAGES_DIR="images"

if [ ! -d thumbs ]
then
	mkdir thumbs/
fi

for IMAGE in $@
do
	IMAGE_EXTENSION=`echo "$IMAGE" | awk -F "." '{print $NF}'`
	IMAGE_BASENAME=`basename "$IMAGE" "$IMAGE_EXTENSION"`
	convert -thumbnail "$THUMBNAIL_SIZE"x "$IMAGE" "thumbs/${IMAGE_BASENAME}_thumb.${IMAGE_EXTENSION}"
	echo "[![](${IMAGES_DIR}/thumbs/${IMAGE_BASENAME}_thumb.${IMAGE_EXTENSION})](${IMAGES_DIR}/${IMAGE})"
done



