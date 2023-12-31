#!/usr/bin/env bash
set -o errexit

usage() { echo "Usage: $0 [-t <threads>] [-i <input-fastq>]" 1>&2; exit 1; }

while getopts ":t:i:" o; do
    case "${o}" in
        t)
            t=${OPTARG}
            (( t > 0 )) || usage
            ;;
        i)
            i=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${t}" ]; then
    t=1
fi

if [ -z "${i}" ]; then
    usage
fi

# trim adapters and low-quality reads
fastp -i $i -o temp_clean.fq 2>/dev/null

## convert FASTQ to FASTA
seqtk seq -A temp_clean.fq > temp.fasta

# dl all REVIEWED (N=148) NB-ARC protein seqs from pfam using API call
python dl_pfam_PF00931.py > PF00931.fa

## make blast db (makes 8 files)
makeblastdb -in PF00931.fa -dbtype prot -out PF00931_db

# identify reads with putative homology to domain
## query reads for homology to domain
blastx -task blastx-fast -query temp.fasta -num_threads $threads -db PF00931_db -out blast_results.txt -outfmt 6 -evalue 1 -mt_mode 1

## filter blast result (filtering for length of match >= 20 & E value less than 1)
awk -F'\t' '($4 >= 20  && $11 < 1)' blast_results.txt > blast_results_filtered.txt

## extract reads with hits
### index FASTA file containing read seqs
samtools faidx temp.fasta

### generate lst of read ids to extract
cut -f1 blast_results_filtered.txt| sort -u > extract.txt

### exact reads described in lst
xargs samtools faidx temp.fasta < extract.txt > chosenones.fa

## count k-mers in all seqs
### generate hash table of canonical K-mers (output is mer_counts.jf, singletons not filtered!)
jellyfish count -m 21 -s 100M -t $threads -C temp.fasta -o mer_counts.jf
jellyfish dump -c mer_counts.jf > counts_all.txt

## count k-mers in chosenones
jellyfish count -m 21 -s 100M -t $threads -C chosenones.fa -o mer_counts.jf
jellyfish dump -c mer_counts.jf > counts_chosen.txt

## output the sum of all k-mers (~coverage) and the mean of k-mers in the chosen ones 
COV=$(awk '{ sum += $2 } END { print sum }' counts_all.txt)
EST=$(awk '{ sum += $2 } END { print sum }' counts_chosen.txt)

## write out
echo -e "$BASE""\t""$COV""\t""$EST"
