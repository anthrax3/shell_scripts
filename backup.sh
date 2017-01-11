#!/bin/bash

# Dependencies check
# 1. Check for PV
pv -V > /dev/null 2>&1
error_code=$?
if [ "${error_code}" != "0" ]; then
	echo "ERROR: pv package is not installed."
	echo "Install it with 'sudo apt-get install pv'"
	exit
fi

# 2. Check for tar
tar --help > /dev/null 2>&1
error_code=$?
if [ "${error_code}" != "0" ]; then
	echo "ERROR: tar package is not installed."
	exit
fi


# Check arguments
if [ "$1" == "" ]; then
	echo "No arguments were supplied."
	echo "Usage: $0 folder_to_compress/"
	exit
fi


#Check if argument is folder
if [ ! -d "$1" ]; then
	echo "ERROR: argument supplied is not a directory."
	exit 
fi


#Compress it
tar -cf - $1 -P | pv -s $(du -sb $1 | awk '{print $1}') | gzip > $1.tar.gz
