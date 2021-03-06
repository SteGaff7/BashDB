#!/bin/bash
if [ $# -lt 3 ]; then
	echo "Error: too few parameters given."
	exit 4
elif ! [ -d $1 ] ; then
	echo "Error: database does not exist."
	exit 5
elif [ -f $1/$2 ] ; then
	echo "Error: table already exists."
	exit 6
elif [ $# -gt 3 ];then
	echo "Error: too many parameters given."
	exit 2
else	
	./P.sh $1
	touch $1/$2
	echo "$3" > $1/$2	
	echo "Table created successfully."
	./V.sh $1
	exit 0
fi
	
