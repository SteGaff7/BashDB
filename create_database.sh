#!/bin/bash
if [ $# -eq 0 ] || [ -z $1 ]; then
	echo "Error: no parameter given."
	exit 1

elif [ $# -gt 1 ]; then
	echo "Error: too many parameters given."
	exit 2

else
	if ! [ -d $1 ]; then
		mkdir $1
		echo "Database made successfully." 
		exit 0
	else
		echo "Error: database already exists."
		exit 3
	fi
fi
