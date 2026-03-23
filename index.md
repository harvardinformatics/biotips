---
title: "[Workshop] Genomics Intuition on the Command Line"
description: Multi-day workshop from Harvard FAS Informatics on Developing Your Bioinformatics Intuition
authors:
    - Danielle Khost
author_header: Workshop Developers
---

# Genomics on the Command Line 

{{ author_row(page) }}

This is a four-part beginner workshop designed to help researchers build confidence in taking a practical first pass look at genomics data on the command line. The goal is not to teach in-depth scripting in Bash, Python, or LLM-based workflows, but to help participants develop a hands-on feel for common bioinformatics file formats, the basic tools available for inspecting them, and the kinds of questions they can answer quickly when something looks off. 

By the end of the workshop, students will:

* be familiar with the “ingredients” (aka command line tools to look at ones data) available to them for pulling out overviews 
* know where to begin troubleshooting problems
* start developing the bioinformatics intuition about their data (e.g. "this file looks weird, I wonder if it's because of X?")

The class will be structured around a series of example file format issues that students will likely encounter and that we will work through the diagnosis and troubleshooting of together. We will be using a combination of command line tools such as `grep`, `awk`, `samtools`, `bedtools`, and `bcftools` to explore the data and answer questions about it.

We will be working with common file types including sequence files (FASTA/Q), alignment files (BAM/SAM), and tabular genomic data such as TSV, CSV, BED, GFF, and GTF. 

This workshop assumes you have some basic knowledge of the Linux command line. If you know several simple commands like `ls`, `cd`, `cp`, and `mv` you should be ok. However, we will go over all the basics on the first day. 

## Setup instructions

These workshops are Jupyter notebooks, which are documents that contain interactive code blocks interleaved with formatted text. You can participate in this workshop by clicking the links below which will open the respective notebooks in [Google Colab :octicons-link-external-24:](https://colab.research.google.com/){ target="_blank" }. That's it! The notebook should load and be able to run without any additional setup.

We will primarily be using the terminal from within the Jupyter notebook to run the commands, but the text/explanation of the workshop will be written in the notebook so you can follow along. 

## Workshop content

Workshop content will be made available below. 

### Day 1: FASTA/FASTQ 

Thursday April 2nd, 9:30 am - 12:30 pm, Location: [Northwest Building :octicons-link-external-24:](https://maps.app.goo.gl/1MqNswcVaTYcCx68A){:target="_blank"} room 453 

* Navigating the command line
* Intro to the FASTA format
* Using `grep` to search and manipulate FASTA files
* Modifying FASTA files with `awk`
* Using `seqtk` to inspect and summarize FASTQ files
* Practical problems: What's wrong with my file??

[Open Jupyter notebook :simple-googlecolab:](#){ .md-button .is-disabled }
- [View Jupyter notebook (non-interactive) :material-arrow-right:](#){ .md-button .is-disabled }

### Day 2: BAM/SAM and other alignment formats

Thursday April 9th, 9:30 am - 12:30 pm, Location: [Northwest Building :octicons-link-external-24:](https://maps.app.goo.gl/1MqNswcVaTYcCx68A){:target="_blank"} room 453 

* Intro to the BAM/SAM format
* samtools for inspecting BAM/SAM files
* What's wrong with my BAM file? Diagnostics
* Visualizing alignments with IGV
* etc

[Open Jupyter notebook :simple-googlecolab:](){ .md-button .is-disabled }
- [View Jupyter notebook (non-interactive) :material-arrow-right:](){ .md-button .is-disabled }


### Day 3: GFF/GTF, BED, VCF, and other tabular genomic data formats

Thursday April 16th, 9:30 am - 12:30 pm, Location: [Northwest Building :octicons-link-external-24:](https://maps.app.goo.gl/1MqNswcVaTYcCx68A){:target="_blank"} room 453

* TSV/CSV files
* Back to "basic" UNIX tools for inspecting tabular data
* Overview of of BED files
* Using `bedtools` to inspect and manipulate interval files


[Open Jupyter notebook :simple-googlecolab:](){ .md-button .is-disabled }
- [View Jupyter notebook (non-interactive) :material-arrow-right:](){ .md-button .is-disabled }


### Day 4: More tabular data

Thursday April 23rd, 9:30 am - 12:30 pm, Location: [Northwest Building :octicons-link-external-24:](https://maps.app.goo.gl/1MqNswcVaTYcCx68A){:target="_blank"} room 453 

* More on BED files
* Other common tabular formats: GTF/GFF, VCF
* Introduction to [`bcftools` :octicons-link-external-24:](https://samtools.github.io/bcftools/bcftools.html){:target="_blank"}

[Open Jupyter notebook :simple-googlecolab:](){ .md-button .is-disabled }
- [View Jupyter notebook (non-interactive) :material-arrow-right:](){ .md-button .is-disabled }


---
