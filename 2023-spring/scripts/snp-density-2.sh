#!/bin/bash

bedtools intersect -c -a poeFor-windows-100k.bed -b data3/poeFor_NW_006799939.vcf | awk 'BEGIN{snps=0; lens=0} {snps+=$4; lens+=$3-$2} END{print snps/lens}'