#!/bin/bash
#SBATCH --job-name=bam-coverage
#SBATCH --partition=test
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24g
#SBATCH --time=1:00:00

samtools sort /n/holylfs05/LABS/informatics/Everyone/workshop-data/biotips-2023/day4/SAMEA3532870_final.bam | samtools coverage > coverage-results.txt