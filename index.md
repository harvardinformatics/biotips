---
title: "[Workshop] Unix tips and tricks for bioinformatics"
description: Multi-day workshop from Harvard FAS Informatics on Unix tips, bioinformatics file formats, sequence processing tools, and scripting basics.
authors:
    - Adam Freedman
    - Danielle Khost
    - Lei Ma
    - Tim Sackton    
    - Gregg Thomas
author_header: Workshop Developers
---

# Unix tips and tricks for bioinformatics <small>(aka Biotips)</small>

{{ author_row(page) }}

This workshop aims to introduce students to some basic bioinformatics file formats, tools, and general best practices. The first two days of the workshop will be dedicated to introductions of bioinformatics file formats and the command line tools that we use to view, manipulate, and analyze them. After that, we will begin to shift from using individual commands to writing shell scripts and constructing bioinformatics workflows.

Each day we'll be going through some hands-on activities to help you get familiar with some basic tools and file formats used in bioinformatics and genomics research. We will do this by running commands and common bioinformatics programs. While this can be achieved on any terminal with the correct programs installed, we have setup the workshop as a series of R Markdown files so that you can follow along and run the commands within RStudio.

This workshop assumes you have some basic knowledge of the Linux command line. If you know several simple commands like `ls`, `cd`, `cp`, and `mv` you should be ok. However, we won't be teaching these basics in this course, so if you aren't familiar with them you may find the course difficult to follow. 

## Before Class

This workshops requires substantial setup before class, so please read through the instructions below and make sure you have everything ready before the workshop starts. Please contact us at least 24 hours before the workshop if you have any questions or issues.

We **_strongly recommend_** that you run these workshops on the [FASRC Cannon cluster :octicons-link-external-24:](https://www.rc.fas.harvard.edu/cluster/){:target="_blank"} so that you can use the same environment as the instructors:

[Biotips setup - Cannon :material-arrow-right:](setup-cannon.md){ .md-button .md-button--primary .centered }

We also provide instructions for running the workshop on your local machine, but you will need to install the required software and packages yourself:

[Biotips setup - Local :material-arrow-right:](setup-local.md){ .md-button .md-button--primary .centered }

---

## Workshop content

Workshop content is available below. R Markdown (.Rmd) files with exercises and solutions are available for download. Additionally, the data files used in the exercises are available for download if you are using a local setup on your own machine.

### Day 1: Bioinformatics tools and file formats 1

Wednesday February 21st, 9:30 am - 12:30 pm, Location: [Northwest Building :octicons-link-external-24:](https://maps.app.goo.gl/1MqNswcVaTYcCx68A){:target="_blank"} room 453 

* Sequence file formats: FASTA, FASTQ
* Intro to commands useful for bioinformatics: `grep`, `awk`
* Alignment file formats: BAM/SAM, [`samtools` :octicons-link-external-24:](http://www.htslib.org/){:target="_blank"}
* Introduction to piping and redirecting output

Download the R Markdown file for the exercises and solutions:

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/Biotips-workshop-Day1-student.Rmd
```

View the rendered version with the exercises and solutions:

[Biotips workshop Day 1 - Genomics formats & tools, part 1 :material-arrow-right:](Biotips-workshop-Day1.md){ .md-button }

Download the data files used in the exercises (local setup only):

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/data/data1.zip
```

### Day 2: Bioinformatics tools and file formats 2

Thursday February 22nd, 9:30 am - 12:30 pm, Location: [Biolabs :octicons-link-external-24:](https://maps.app.goo.gl/mtqAuyd1HwFRLJyZ6){:target="_blank"} room 2062/2064 

* More on piping and redirecting output
* Interval files: bed, GFF
* More on `grep` and `awk`
* Intro to [`bedtools` :octicons-link-external-24:](https://bedtools.readthedocs.io/en/latest/index.html){:target="_blank"}

Download the R Markdown file for the exercises and solutions:

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/Biotips-workshop-Day2-student.Rmd
```

View the rendered version with the exercises and solutions:

[Biotips workshop Day 2 - Genomics formats & tools, part 2 :material-arrow-right:](Biotips-workshop-Day2.md){ .md-button }

Download the data files used in the exercises (local setup only):

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/data/data2.zip
```

### Day 3: Shell scripting 1

Wednesday February 28th, 9:30 am - 12:30 pm, Location: [Northwest Building :octicons-link-external-24:](https://maps.app.goo.gl/1MqNswcVaTYcCx68A){:target="_blank"} room 353 (NOTE ROOM CHANGE FROM DAY 1)

* More about interval files: bed, GFF
* Variant files: VCF
* Introduction to [`bcftools` :octicons-link-external-24:](https://samtools.github.io/bcftools/bcftools.html){:target="_blank"}
* Shell scripting

Download the R Markdown file for the exercises and solutions:

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/Biotips-workshop-Day3-student.Rmd
```

View the rendered version with the exercises and solutions:

[Biotips workshop Day 3 - Shell scripting, part 1 :material-arrow-right:](Biotips-workshop-Day3.md){ .md-button }

Download the data files used in the exercises (local setup only):

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/data/data3.zip
```

### Day 4: Shell scripting 2

Thursday February 29th, 9:30 am - 12:30 pm, Location: [Biolabs :octicons-link-external-24:](https://maps.app.goo.gl/mtqAuyd1HwFRLJyZ6){:target="_blank"} room 2062/2064 

* Loops
* Conditional statements
* Handling command line arguments in shell scripts
* Reproducibility best practices

Download the R Markdown file for the exercises and solutions:

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/Biotips-workshop-Day4-student.Rmd
```

View the rendered version with the exercises and solutions:

[Biotips workshop Day 4 - Shell scripting, part 2 :material-arrow-right:](Biotips-workshop-Day4.md){ .md-button }

Download the data files used in the exercises (local setup only):

```bash
wget https://informatics.fas.harvard.edu/workshops/biotips/data/data4.zip
```

---