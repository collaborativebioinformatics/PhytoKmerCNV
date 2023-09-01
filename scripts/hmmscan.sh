#!/bin/bash 
for i in *.pep.fa.gz
do
	# determine basename for output
	BASE=$(echo "$i" | cut -f1 -d".")
	
	# hmmscan
	hmmscan --tblout "$BASE"_hmmscan.txt  NB-ARC.hmm "$i"
	
done
