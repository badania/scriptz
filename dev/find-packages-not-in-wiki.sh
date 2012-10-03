#!/bin/bash
#Look for packages that are references in the distro's package list, but not in the wiki.
#https://rxtx-linux.googlecode.com/

packagelistsdir="~/git/rxtx-linux/live-build/config/packagelists/"
for pattern in `cat "$packagelistsdir"/rxtx.list`; 
do
	if grep -r "$pattern" $HOME/svn/svn/wiki/*
		then true
		else echo "$pattern Not found" >> errors
	fi
done
