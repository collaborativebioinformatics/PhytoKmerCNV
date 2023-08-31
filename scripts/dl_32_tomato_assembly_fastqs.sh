#!/bin/sh

# Downloads the SRA run accessions for HiFi reads of 32 tomato assemblies from
# https://www.nature.com/articles/s41586-022-04808-9#Sec23; SRA project PRJNA733299,
# and converts them to FASTQ format.

ACCESSIONS=`for i in $(seq -f %02g 32); do echo "SRR152437$i"; done`

for i in $ACCESSIONS; do
  aws s3 cp --no-sign-request s3://sra-pub-run-odp/sra/$i/ . --recursive;
  fasterq-dump $i;
  rm -r $i
done
