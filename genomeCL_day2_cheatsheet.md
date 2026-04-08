# Genomics Command Line Day 2 Cheat Sheet

Quick reference for the commands used in [genomeCL_day2.ipynb](https://github.com/harvardinformatics/biotips/blob/main/genomeCL_day2.ipynb).


## `samtools view`

```bash
# Show the first few alignment lines from the SAM file.
samtools view data_day2/example.sam | head

# Show the header plus the first few SAM alignments.
samtools view -h data_day2/example.sam | head

# Show the first few alignments from the BAM file.
samtools view data_day2/example.bam | head

# Convert a BAM file to SAM.
samtools view -o converted.sam data_day2/example.bam

# Convert a SAM file to BAM.
samtools view -b -o converted.bam data_day2/example.sam

# Convert a SAM file to BAM while keeping the header.
samtools view -h -b -o converted.bam data_day2/example.sam
```

## Filtering by Flags

```bash
# Show only mapped reads by excluding flag 4.
samtools view -F 4 data_day2/example.sam | head

# Count unmapped reads.
samtools view -f 4 data_day2/example.bam | wc -l

# Count reads mapped in proper pairs.
samtools view -f 2 data_day2/example.bam | wc -l

# Count reads not mapped in proper pairs.
samtools view -F 2 data_day2/example.bam | wc -l

# Count reads whose mate is unmapped but the read itself is mapped.
samtools view -f 8 -F 4 data_day2/example.sam | wc -l
```

## Sorting and Indexing

```bash
# Sort a BAM file by coordinate.
samtools sort -o file.sorted.bam data_day2/example.bam

# Create an index for the sorted BAM file.
samtools index file.sorted.bam
```

## Subsetting by Region

```bash
# Extract all alignments on chromosome 1.
samtools view -o chr1.bam data_day2/example.bam chr1

# Extract alignments from a subregion of chromosome 1.
samtools view -o chr1_subregion.bam data_day2/example.bam chr1:1000-2000
```

## `samtools stats`

```bash
# Write a full stats report for the BAM file.
samtools stats data_day2/example.bam > data_day2/example.bam.stats

# Keep only summary lines from the stats report.
samtools stats data_day2/example.bam | grep '^SN' > data_day2/example.bam.stats.txt
```

## Converting to FASTQ

```bash
# Output only mapped reads to FASTQ.
samtools view -F 4 data_day2/example.bam | samtools fastq -o mapped_reads.fastq

# Output mapped, primary, non-supplementary reads to FASTQ.
samtools view -F 2308 data_day2/example.bam | samtools fastq -o mapped_reads.fastq
```

## Coverage and Depth

```bash
# Summarize coverage across the BAM file.
samtools coverage data_day2/example.bam

# Summarize coverage for one region.
samtools coverage -r chr1:1000-2000 data_day2/example.bam

# Calculate depth at every position and save it to a file.
samtools depth -o data_day2/example.bam.depth.txt -a data_day2/example.bam
```
