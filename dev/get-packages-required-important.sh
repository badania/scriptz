#!/bin/bash
#This script lists packages that are priority required and important.
#https://rxtx-linux.googlecode.com/

aptitude search -F'%p' ~prequired ~pimportant
