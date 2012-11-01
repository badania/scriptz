#!/bin/bash
#finds git repositories on the system
#TODO: allow selecting base directory
for i in `find -L /home -name ".git" -type d 2>/dev/null`; do dirname "$i"; done
