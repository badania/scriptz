#!/bin/bash
#create a bare git repository, add correct permissions
mkdir $1
cd $1
git init --bare
cd ../
chown -R www-data:www-data $1
