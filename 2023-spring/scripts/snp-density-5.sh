#!/bin/bash

BEDFILES=$1
VCF=$2

if [[ ! -f "$VCF" ]];
then
    echo "$VCF does not exist. Exiting script."
    exit 1
fi

for BEDFILE in $(cat $BEDFILES)
do
    if [[ -f "$BEDFILE" ]];
    then
        echo "SNP density for $BEDFILE:"
        bedtools intersect -c -a $BEDFILE -b $VCF | awk 'BEGIN{snps=0; lens=0} {snps+=$4; lens+=$3-$2} END{if(lens > 0){print snps/lens}}'
        echo "---"
    else
        echo "$BEDFILE does not exist. Skipping this file."
    fi
done