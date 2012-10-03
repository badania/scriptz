#!/bin/bash
#Use this script to fix the "corrupted package lists" error.

sudo apt-get clean
sudo rm -r /var/lib/apt/lists
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean
sudo aptitude update
