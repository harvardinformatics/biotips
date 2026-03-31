#!/bin/bash

#
# This script takes a file of bed files and a VCF file and calculates average SNPs per base for each bed file
# Usage: ./snp-density-final.sh <file of bed files to process> <vcf file>
#

BEDFILES=$1
VCF=$2

if [[ -z $BEDFILES || -z $VCF ]]
then
  echo "Usage: ./snp-density-final.sh <file of bed files to process> <vcf file>"
else
  for BEDFILE in $(cat $BEDFILES)
  do
    if [[ -e $BEDFILE ]]
    then
      echo "SNP density for $BEDFILE:"
      bedtools intersect -c -a $BEDFILE -b $VCF | awk 'BEGIN{snps=0; lens=0} {snps+=$4; lens+=$3-$2} END{if(lens > 0){print snps/lens}}'
      echo "---"
    else
      echo "File $BEDFILE does not exist. Skipping!"
    fi
  done
fi