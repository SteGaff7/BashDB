#!/bin/bash
if [ $# -lt 3 ] ; then
        if [ -d $1 ] && [ -f $1/$2 ]; then
                echo "start_result"
                cat $1/$2
                echo "end_result"
                exit 0
        else
                echo "Error: too few parameters given."
                exit 4
        fi

elif ! [ -d $1 ] ; then
        echo "Error: database does not exist."
        exit 5

elif ! [ -f $1/$2 ] ; then
        echo "Error: table does not exist."
        exit 7

#This is the 'Bonus' code for the where clause. This is simply a copied and modified code from the code below
elif [ $# -eq 5 ] ; then
        numberLines=`wc -l < $1/$2`
        desiredCols=`echo $3 | tr -d ","`
        commaTableHeader=`head -n1 $1/$2 | grep -o "," | wc -l`
        reverse=`echo $desiredCols | rev`
        if ! [ "${reverse:0:1}" -gt "$(expr "$commaTableHeader" + 1)" ]; then
                count=0
		echo "start_result"
                echo
                for i in $(eval echo {1..$numberLines}); do
			checkString=$(sed -n ${i}p $1/$2 | cut -d ',' -f "$4")
                        if [ "$checkString" = $5 ]; then
				count=$(($count+1))
                                for j in $(eval echo {0..`expr ${#desiredCols} - 1`}); do
                                #index desired cols and retrieve value of index to pass to field
                                        fieldIndex=${desiredCols:$j:1}
                                        subString=$(sed -n ${i}p $1/$2 | cut -d ',' -f $fieldIndex)
					printf "$subString "
                                done
                                echo
                        fi
                done
		if [ "$count" = 0 ]; then
			echo "No results found!"
		fi
                echo
                echo "end_result"
                exit 0
        else
                echo "Error: columns specified in query out of range, $(expr "$commaTableHeader" + 1) columns in this table."
                exit 9
        fi

elif [ $# -eq 3 ]; then
        numberLines=`wc -l < $1/$2`
        desiredCols=`echo $3 | tr -d ","`
        commaTableHeader=`head -n1 $1/$2 | grep -o "," | wc -l`
        reverse=`echo $desiredCols | rev`
        if ! [ "${reverse:0:1}" -gt "$(expr "$commaTableHeader" + 1)" ]; then
                echo "start_result"
		echo
                for i in $(eval echo {1..$numberLines}); do
			for j in $(eval echo {0..`expr ${#desiredCols} - 1`}); do
                                #index desired cols and retrieve value of index to pass to field
                                fieldIndex=${desiredCols:$j:1}
                                substring=$(sed -n ${i}p $1/$2 | cut -d ',' -f $fieldIndex)
                                printf "$substring "
			
                        done
			echo
                done
		echo
		echo "end_result"
		exit 0
        else
                echo "Error: columns specified in query out of range, $(expr "$commaTableHeader" + 1) columns in this table."
                exit 9
        fi
else 
	echo "Error: Too many parameters given. Select - select + 3 parameters. Where clause - request + 5 arguements (select database table columns column value)"
	exit 2
fi
