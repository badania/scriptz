#!/bin/bash
#Fix for Zsnes missing 32bit OpenGL libs
sudo ln -s /usr/lib32/mesa/libGL.so.1.2 /usr/lib/libGL.so.1
