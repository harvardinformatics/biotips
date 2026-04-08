# Genomics Command Line Day 1 Cheat Sheet

Quick reference for the commands used in [genomeCL_day1.ipynb](/Users/daniellekhost/github/biotips/genomeCL_day1.ipynb).

## Setup and Navigation

```bash
# Print your current working directory.
pwd

# List files in the current directory.
ls

# List files with detailed information.
ls -l

# List files with human-readable sizes.
ls -lh

# List the downloaded day 1 data files.
ls data_day1/

# Find one specific FASTA file by name.
find ./ -name 'example.fasta'

# Find all FASTA files under the current directory.
find ./ -name '*.fasta'
```

## Displaying file contents

```bash
# Print the whole FASTA file to the terminal.
cat data_day1/example.fasta

# Show the beginning of the FASTA file.
head data_day1/example.fasta

# Show the end of the FASTA file.
tail data_day1/example.fasta

# Open the FASTA file in a scrollable viewer.
less data_day1/example.fasta

# Count how many lines are in the FASTA file.
wc -l data_day1/example.fasta
```

## Searching with `grep`

```bash
# Print FASTA header lines.
grep '>' data_day1/example.fasta

# Find headers containing chr, ignoring case.
grep -i '>chr' data_day1/example.fasta

# Count lines containing the > character.
grep -c '>' data_day1/example.fasta

# Print only sequence lines by excluding headers.
grep -v '>' data_day1/example.fasta

# Print the chr1 header and the line after it.
grep -A 1 '>chr1' data_day1/example.fasta

# Match only the exact chr1 header.
grep -w '>chr1' data_day1/example.fasta
```

## Redirects and Pipes

```bash
# Extract chr_1 plus one sequence line into a new file.
grep -A 1 'chr_1' data_day1/assembly_1.fasta > data_day1/chr1.fasta

# Pipe text into sed for a quick replacement example.
echo "oh time time thy pyramids" | sed 's/time/test/g'
```

## Editing with `sed`

```bash
# Replace D.mel with DMEL and save to a new FASTA file.
sed 's/D.mel/DMEL/g' data_day1/assembly_1.fasta > data_day1/fixed_headers.fasta

# Remove the > character from FASTA headers.
grep '>' data_day1/assembly_1.fasta | sed 's/>//'

# Print only line 6.
sed -n '6p' data_day1/assembly_1.fasta

# Print lines 1 through 5.
sed -n '1,5p' data_day1/assembly_1.fasta

# Delete line 1.
sed '1d' data_day1/assembly_1.fasta 

# Delete a large block of lines.
sed '2,20006d' data_day1/assembly_1.fasta

# Remove all FASTA header lines.
sed '/>/d' data_day1/assembly_1.fasta 
```

## FASTA Tools with `seqkit`

```bash
# Summarize sequence counts and lengths.
seqkit stats data_day1/assembly_1.fasta

# Convert sequences to uppercase.
seqkit seq -u data_day1/assembly_1.fasta 

# Reverse complement the sequences.
seqkit seq -r -p data_day1/assembly_1.fasta

# Keep only sequences at least 100 bp long.
seqkit seq -m 100 data_day1/assembly_1.fasta

# Remove gaps, then summarize again.
seqkit seq -g data_day1/assembly_1.fasta | seqkit stats

# Extract sequences whose header matches chr1.
seqkit grep -p 'chr1' data_day1/assembly_1.fasta

# Extract all sequences with chr in the header and save them.
seqkit grep -r -p 'chr' data_day1/assembly_1.fasta > data_day1/assembly_1_chr_sequences.fasta

# Replace chr with chromosome in headers.
seqkit replace -p 'chr' -r 'chromosome' data_day1/assembly_1.fasta

# Add sequence_ to the start of each header.
seqkit replace -p ^ -r sequence_ data_day1/assembly_1.fasta
```
