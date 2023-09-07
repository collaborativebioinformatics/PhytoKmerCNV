#!/bin/sh
# dl test data
# cjfiscus
# 2023-09-07

# dl peptide seqs for 32 genome assemblies described here
# https://www.nature.com/articles/s41586-022-04808-9#data-availability

## data goes here
cd ../data

## dl .pep and md5s
wget -r --no-parent -nd -A ".gz" https://solgenomics.net/ftp/genomes/TGG/pep/
wget -r --no-parent -nd -A ".txt" https://solgenomics.net/ftp/genomes/TGG/pep/

## checksums
for i in *.fa.gz.md5.txt
do
    md5sum -c "$i"
done
