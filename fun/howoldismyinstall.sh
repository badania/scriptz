#!/bin/sh
#Description: Show how old your linux OS installtion is
#..not guaranteed to always be accurate but fun to see how old you Linux installation is based on the root partitions file system creation date.
#Source: http://www.commandlinefu.com/commands/view/12590/show-how-old-your-linux-os-installtion-is

sudo tune2fs -l `df --output=source / | tail -1` | grep -i created
