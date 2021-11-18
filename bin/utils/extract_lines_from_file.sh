#!/bin/bash

# Given a file (linenums_file) containing a sorted list of numbers,
# one per line, extract those line numbers from another file
# (extract_file)

linenums_file=$1
extract_file=$2

##### MANUAL ERROR HANDLING #####
# Verify line numbers file contains one integer per line
n=`grep -v "^[1-9][0-9]*$" $linenums_file | wc -l`
if [[ $n -gt 0 ]]; then
	echo "The file of line numbers must only contain one integer per line"
	exit 1
fi;

# Verify line numbers exist in file to extract from
n1=`sort -g $linenums_file | tail -n 1`
n2=`cat $extract_file | wc -l`
if [[ $n1 -gt $n2 ]]; then
	echo "Line numbers must not be greater than the number of lines in extraction file"
	exit 1
fi;
#####

awk 'NR == FNR {nums[$1]; next} FNR in nums' $linenums_file $extract_file 

