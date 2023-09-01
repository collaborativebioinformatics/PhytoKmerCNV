#!/bin/bash
## rough steps of pl
## cjfiscus
## 3034-08-30

########## SOFTWARE
## seqtk (https://github.com/lh3/seqtk)
## blast+ (command line BLAST, https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html)
## samtools (https://github.com/samtools/samtools)
## jellyfish (https://github.com/gmarcais/Jellyfish)

########## GATHER TEST DATA
# sequencing data
## dl some  seq data to play with SRR1572249 (paired end illumina, but only dl one side)
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR157/009/SRR1572249/SRR1572249_1.fastq.gz

## sample 100000 reads (for prototyping)
seqtk sample -s100 SRR1572249_1.fastq.gz 100000 > temp.fq

## convert FASTQ to FASTA
seqtk seq -A temp.fq > temp.fasta


# dl all REVIEWED (N=148) NB-ARC protein seqs from pfam using API call (python 3)
python dl_pfam_PF00931.py > PF00931.fa

## make blast db (makes 8 files)
makeblastdb -in PF00931.fa -dbtype prot -out PF00931_db
##########
# PIPELINE

# identify reads with putative homology to domain (we need to parallelize this!!!)
## query reads for homology to domain
blastx -query temp.fasta -db PF00931_db -out blast_results.txt -outfmt 6

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
jellyfish count -m 21 -s 100M -t 2 -C temp.fasta 

### generate tab output
jellyfish dump -c mer_counts.jf > counts_all.txt

## count k-mers in chosenones
jellyfish count -m 21 -s 100M -t 2 -C chosenones.fa
jellyfish dump -c mer_counts.jf > counts_chosen.txt


## output the sum of all k-mers (~coverage) and the mean of k-mers in the chosen ones 
COV=$(awk '{ sum += $2 } END { print sum }' counts_all.txt)
EST=$(awk '{ sum += $2 } END { mean = sum / NR; print mean }' counts_chosen.txt)

## write out
echo -e "sample_name\t""$COV""\t""$EST"
