#!/bin/bash
#Look for packages that are referenced in rxtx.list.chroot , but not in the wiki.
#License: 

packagelistsdir="~/git/rxtx-linux/live-build/config/packagelists/"
for pattern in `cat "$packagelistsdir"/rxtx.list`; 
do
	if grep -r "$pattern" $HOME/svn/svn/wiki/*
		then true
		else echo "$pattern Not found" >> errors
	fi
done
