#!/bin/bash                 
if [ $# -lt 3 ] ; then
        echo "Error: too few parameters given."
        exit 4
elif [ $# -gt 3 ]; then
	echo "Error: too many parameters given."
	exit 2
elif ! [ -d $1 ] ; then
        echo "Error: database does not exist."
        exit 5
elif ! [ -f $1/$2 ] ; then
        echo "Error: table does not exist."
        exit 7
else
	commaThisRow=`echo $3 | grep -o "," | wc -l `
	commaThisTable=`head -n1 $1/$2 | grep -o "," | wc -l`
	if [ $commaThisRow -eq $commaThisTable ] ; then
		./P.sh $2
		echo "$3" >> $1/$2
       		echo "Tuple inserted successfully."
		./V.sh $2
		exit 0
	else
		echo "Error: number of columns entered does not match number of columns($(expr $commaThisTable + 1)) in table."
		exit 8
	fi
fi
