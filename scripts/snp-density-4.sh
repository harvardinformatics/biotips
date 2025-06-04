#!/bin/bash

BED=$1
VCF=$2

bedtools intersect -c -a $BED -b $VCF | awk 'BEGIN{snps=0; lens=0} {snps+=$4; lens+=$3-$2} END{print snps/lens}'