#!/bin/bash

# This script takes a file of sequences, one per line, not a fasta! 
# The file must be uncompressed
# RNAfold is used to get the centroid structure for each sequence
# And a file is returned called: prefix_alphabet_annotations.tab

# The script takes the name of a file and location of the Lib directory
file=$1
libpath=$2
prefix=$3
temp=$4
clean=$5

# A directory is created to temporarily hold all RNAfold output
currdir=${prefix}_RNAfold
mkdir $currdir

cat $file > ${currdir}/${prefix}.tab

# Fold sequences, split file into chunks of 50,000 to avoid 
# overwhelming the system with the output RNAfold produces
cd $currdir
split -l 50000 ${prefix}.tab x
N=`cat ${prefix}.tab | wc -l`
counter=0
echo "Folding $N $prefix probes"
for x in x*; do
	RNAfold -p -T $temp --noPS < $x >> ${prefix}_RNAfold_output.txt
	rm -rf *.ps
	n=`cat $x | wc -l`
        counter=$(( counter + n ))
        echo "$counter probes of $N have been folded"
done
cd ..

# Clean up folding files
mv ${currdir}/${prefix}_RNAfold_output.txt .
rm -rf ${currdir} 

# Extract centroid structures
sed -n '4~5p' ${prefix}_RNAfold_output.txt | grep -o "^[.)(]*" > ${prefix}_structures.tab

# Annotate dot bracket structures to 7-letter structural alphabet
# And compile information into: prefix_centroid_struct_annotations.tab
${libpath}/utils/parse_secondary_structure_v2 ${prefix}_structures.tab ${prefix}_annotated.tab
paste $file ${prefix}_structures.tab ${prefix}_annotated.tab > ${prefix}_centroid_struct_annotations.tab

# Remove redundant files
rm -f ${prefix}_annotated.tab ${prefix}_structures.tab ${prefix}_RNAfold_output.txt

# Generate annotation file containing all annotations for 7-letter alphabet
# Also adds column of probe names in format ${prefix}_linenumber
python ${libpath}/annotate_alphabets.py ${prefix}_centroid_struct_annotations.tab $prefix

# Clean up
if [[ $clean == "TRUE" ]]; then
	rm -f ${prefix}_centroid_struct_annotations.tab
else
	gzip ${prefix}_centroid_struct_annotations.tab	
fi;

