#!/bin/bash
#Description: lists packages that have priority required and important.

aptitude search -F'%p' ~prequired ~pimportant
