#!/bin/bash

BED="poeFor-windows-100k.bed"
VCF="data3/poeFor_NW_006799939.vcf"

bedtools intersect -c -a $BED -b $VCF | awk 'BEGIN{snps=0; lens=0} {snps+=$4; lens+=$3-$2} END{print snps/lens}'