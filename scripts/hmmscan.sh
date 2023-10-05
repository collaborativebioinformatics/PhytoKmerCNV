#!/bin/bash
# tally NB-ARC genes per pep annot
# 

# make output
OUT=nbarc_counts.txt
touch "$OUT"

# count per annot
for i in *.pep.fa.gz
do
	# determine basename for output
	BASE=$(echo "$i" | cut -f1 -d".")
	
	# hmmscan
	hmmscan --tblout "$BASE"_hmmscan.txt  NB-ARC.hmm "$i"
	
	# process result
	NUM_GENES=$(grep -v "#" "$BASE"_hmmscan.txt | awk '{print $3}' | sort -u | wc -l)
	echo -e "$BASE""\t""$NUM_GENES" >> "$OUT"
done