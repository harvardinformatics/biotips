---
title: "[Workshop] Biotips Day 1: Bioinformatics command line tools and file formats"
description: "Introduction to FASTA, FASTQ, and SAM/BAM files, as well as grep, awk, and samtools."
date: "February 21, 2024"
authors: 
  - Danielle Khost
  - Adam Freedman
  - Lei Ma
  - Gregg Thomas
output: 
  html_document:
    keep_md: true
editor_options: 
  chunk_output_type: inline
---

# Biotips Day 1: Bioinformatics command line tools and file formats, part 1

Welcome to the first day of the [FAS Informatics](https://informatics.fas.harvard.edu/) Bioinformatics Tips & Tricks workshop!

If you're viewing this file on the website, you are viewing the final, formatted version of the workshop. The workshop itself will take place in the RStudio program and you will *edit and execute the code in this file*. Please download the raw file [here :octicons-download-24:](Biotips-workshop-Day1-student.Rmd)

This is the workshop file that should be opened in RStudio. This is an RMarkdown file, meaning that both formatted text and code blocks can be added to it, and the code blocks can be executed from the RStudio interface. RStudio also has an easy to access **Terminal** tab which is how one would normally execute **Unix** commands. For this workshop, we will be going through this document and copy-pasting code blocks within it to run in the terminal to demonstrate some basic concepts. We will also be doing exercises directly in the terminal panel of RStudio. Once you've got the correct command, you can paste it into the RMarkdown document to keep a record.

## Bioinformatics Tools, Part 1

The first two days of this workshop are designed to get you familiar with the different types of common file formats you will often come across in many bioinformatics pipelines, and are designed to mimic the flow of a typical pipeline from raw sequence files to variants called against a reference genome. In this first session we will discuss sequence files and alignment files, as well as some tools and **commands** used to manipulate them!

## A note on Unix commands

We should ground ourselves a bit before we get too into the weeds, simply by defining what we mean when we say the word **command**. A **command** is basically just an instruction to tell a program to do something. It is a chunk of code that someone has written that takes input, processes that input, and produces output. The really common and useful chunks of code (e.g. `ls` or `cd`) have become mainstays in modern operating systems to the extent that we don't even need to think about the underlying code, but it is there.

Seeing a bunch of these commands with weird names (like `grep` and `awk` and `samtools`) and lots of options (e.g. `-l`, `-c`, `-A10`, etc.) can make things really confusing for someone that's not used to dealing with them. Many commands, and a lot of bioinformatics in general, simply rely on plain-text formatted files. When it comes down to it, most of the commands we'll use over the next few days, no matter how complicated they look, really just do the following:

**formatted text -> command -> processed text**

(Technically, this kind of command is called a 'filter'. Some commands, such as `ls`, don't operate on text, and others, such as `cd`, don't even produce output. But these details aren't that important for our class today.)

This is central to the Unix philosophy. And this means that two things are really important:

1.  **Text formatting** is very important! Knowing the expected input format for a command means you can format your data correctly and know which files can be used with the command.
2.  Being able to **easily view and manipulate** text files becomes crucial for a productive bioinformatician. An important aspect of this is that one should always **look at their data**! That way they can get familiar with the different types of file formats out there and become accustomed to spotting errors before moving on with their data processing or analysis.

Some common file formats in data science simply encode **tables of data** with rows being observations and columns being features of each observation. Columns are usually are usually designated by a separator character, commonly comma (`,`) with files that have `.csv` **extensions** or a tab (often encoded as `\t`) with files that have `.tsv` or `.tab` **extensions**. **File extensions** are a nice way to give us a clue to how the data in the file is formatted. But note that the **extension** does not necessarily define how the data is formatted -- the agreement between the file's extension and its format is not enforced by the machine and is only meant to be descriptive. You may sometimes find a tab delimited file with the `.txt` extension, or even with `.csv`! Best practices dictate that the extension match the formatting, but best practices are not always followed.

In this workshop we will also see file formats specific for genomic data: sequences are encoded in `.fasta` or `.fastq` files, alignments of sequenced reads are encoded in `.sam` files, intervals in a genome are encoded in `.bed` files, and genomic variation relative to a reference genome is encoded in `.vcf` files. Though I will note that, with the exception of `.fasta` and `.fastq` files, these are all simply **tab delimited** files with columns specific to genomic data!

For more information on some common genomics file formats, see [here :octicons-link-external-24:](https://harvardinformatics.github.io/workshops/2024-spring/biotips/terms.html#formats){:target="_blank"}

**One of the most important things I can tell you about bioinformatics is to always remember what file formats your data are in!**

## A note on terminology

In the section above and throughout this workshop we use a lot of context dependent terms. For instance, you probably know what the word "command" means in general usage, but in the context of computer science it has a specific meaning that may not be obvious. This brings up an important point I try to remember when teaching. When learning a new skill or set of skills there's usually a whole new vocabulary to learn that goes along with it. What makes it difficult is that those teaching the new skill will use this vocabulary, and since they are so familiar with it they oftentimes won't even realize people don't know what the words they're using mean in the context of the new skillset.

In an attempt to offset this unintentional language barrier we provide tables with some contextual definitions of terms we may use throughout the workshop at the following link:

[Computing Glossary :material-arrow-top-right:](../../resources/glossary.md){:target="_blank" .md-button .md-button--primary .centered }

If you see or hear any terms you think should be added to these tables, please let us know.

## Setup

To avoid having to either type out out long paths or copy workshop data to your local directory, we'll create a *symbolic link* (analogous to a Windows *shortcut*) in your current working directory called "data" that points to the workshop data directory.

> Run the following command to create a link to our data directory in your current directory:

**Note that whenever you see the > character followed by green text, this is an exercise or action to be done by you!**

```bash

ln -s -f /n/holylfs05/LABS/informatics/Everyone/workshop-data/biotips-2024/day1 data1
## ln: The Unix link command, which can create shortcuts to folders and files at the provided path to the second provided path
## -s: This option tells ln to create a symbolic link rather than a hard link (original files are not changed)
## -f: This option forces ln to create the link

ls -l data1
## Show the details of the new linked directory

```

Now you can access a given file in that directory by simply referencing `data1/<filename>` in your code.

## Sequence files

### FASTA

Probably the most common file format used to represent biological sequences is the **FASTA** format (whose name is derived from a software package written in the 1980s). A FASTA file is composed of a number of *entries*, and can be either protein or nucleotide sequences. An "entry" can represent a number of things; for instance, if you were working with a FASTA file that you got back from the sequencing center, each entry would correspond to a single read off the sequencer. Alternatively, if you downloaded a whole genome assembly off NCBI, each entry would correspond to a scaffold or contig in the assembly.

Each entry is comprised of two lines:
- *Header line*, which starts with a `>` symbol. This contains the unique name for each entry (e.g. >chr1), optionally followed by additional metadata.
- *Sequence line*, which follows a header line. This is a string of either nucleotides or amino acids and represents the actual sequence

**Note**: for some FASTA files, the sequence line can be set to wrap every certain number of characters (e.g. every 50 nucleotides). These are referred to as *multi-line FASTA*, and can make your life difficult...make sure you know whether your FASTA is multi-line or single-line! For example,

```
>sequence1
ATGGACGCTAGTCAGTAGATGCATGCTGACCCAACATAACG
```

vs.

```
>sequence1
ATGGACGCTAG
TCAGTAGATGC
ATGCTGACCCA
ACATAACG
```

The sequences in these two examples are identical, but one is broken up by lines. Most programs can automatically handle both types of **FASTA** files, but as we stated above, if you parse your own **FASTA** files, you need to be aware of the difference!

Now, let's look at a small test FASTA file as an example. There are many different ways to view the contents of a file at the command line. Here are a few tools that are included in a typical Unix-like system (e.g. the Cannon computing cluster here at Harvard) that we will be using today:

-   `cat`: prints entire file to screen (short for conCATenate)
-   `head`: prints the first 10 lines of a file by default. We can change how many lines printed by adding the `-n #` argument, e.g. `head -n 5` prints only the first five lines
-   `tail`: the opposite of `head`, it prints the *last* 10 lines of a file
-   `less`: rather than printing the entire file contents to screen at once, `less` allows you to scroll through using the arrow keys. Using `less` will open the file as a sub-window; **close `less` by pressing 'q'**. This is especially useful when working with large files
-   `wc -l`: technically this is not a way to view a file's contents, but is still good to know! `wc` stands for 'word count', which as the name suggests counts the number of words in the file, and the `-l` argument instead makes it count the number of *lines* in the file

OK, now let's actually look at the file! Since it is only a small test file, we will use `cat`.

> Run the following command in the terminal to view an example FASTA formatted file:

```bash

cat data1/test.fa
## cat: A Unix command to display the contents of a file (or multiple files) to the screen

```

Let's also see how many lines are in the file.

> Run the code below in the terminal to count the lines in the FASTA file:

```bash

wc -l data1/test.fa
## wc: the Unix word count command
## -l: tells wc to only return the line count

```

> **Exercise**:
> Write a command using one of the tools listed above to display only the first 4 lines of the FASTA file. Once you've got it, run it in the terminal to check and make sure it works.

```bash

### Write a command to print the first four lines of the FASTA file
## data1/test.fa
head -n 4 data1/test.fa

```

### A note about getting help

We can see with the `wc` command that we are using the `-l` option to tell the command to count lines in our file. How do we find out about what other options this command might have? Well, searching the internet is fine, but most command line tools also have built in help.

> Run the following command in the terminal to see the help menu for the `wc` command:

```bash

man wc

```

`man` is itself a command, short for **man**ual. Most command line tools that come built in with Linux have a manual page that you can read with the `man` command.

Tools that you install yourself, such as `samtools` that we will discuss later, usually don't have man pages. However, many programs have a command line help that can be accessed with the `-h` or `--help` options, or alternatively will display their help output if run with no arguments or options.

### Back to fasta files

Because they are so universal to bioinformatics, it is worthwhile to get comfortable with FASTA files and all the useful information we can pull out of them! To do so, let's look at our first command line tool:

### Manipulating files with `grep`

`grep` is a powerful command-line search tool that is included as part of Unix-like systems. At the most basic level, `grep` searches for a string of characters that match a pattern and will print lines containing a match. The basic syntax is as follow:

```
grep 'pattern' file_to_search.txt
```

This may seem simple, but `grep` is one of the most useful tools in bioinformatics! For example, if we wanted the sequence headers for every entry in our **FASTA** file, we could do the following.

> Run the code block below in the terminal to print all the sequence headers in the FASTA file to the screen:

```bash

grep '>' data1/test.fa
## grep: The Unix string search command
## '>': The string to search for in the provided file

```

By default, `grep` will return a match if *any part of the string* matches your pattern. For instance, say we wanted to pull out the headers that correspond only to **chr**omosomes. If you attempt to match pattern `c` what would happen?

> **Exercise**:
> Write a grep command to print all lines that contain the 'c' character in the FASTA file. Run the code in the terminal.

```bash

### Write a command to display all lines with the 'c' character
## data1/test.fa
grep 'c' data1/test.fa

```

You can see that not only are we pulling out headers that do not correspond to chromosomes, we are even getting a sequence line that contains a lowercase 'c'! We would instead need be more specific with the string we are trying to search for.

> **Exercise**:
> Use a more specific string pattern to match only headers that correspond to chromosomes in the FASTA file. Run the code in the terminal.

```bash

### Write a command to display all lines that correspond to chromosomes
## data1/test.fa
grep '>chr' data1/test.fa

```

This is getting better...notice that by matching `>chr` we are correctly getting the line '>chromosome4', as it is still a partial match. However, we are still missing a sequence, '>Chr3'! This is because by default `grep` is *case-sensitive*. Thankfully, we can fix that.

#### Modifying `grep`

`grep` can take a huge number of arguments that modify how it behaves (which you can always check by typing `man grep`), but here we will highlight just a few that are especially useful.

`grep -i` allows case-insensitive matches. So to return to our above problem, we can specify to ignore the case.

> Run the code below to print all lines that contain the '>chr' string in the FASTA file, ignoring the case of the letters in the string:

```bash

grep -i '>chr' data1/test.fa
## grep: The Unix string search command
## -i: An option the tells grep to ignore the case of the matches, e.g. >chr will match >CHr and >Chr, etc., as well as >chr
## '>chr': The string to search for in the provided file

```

`grep -c` counts the number of times a match occurs. One of the most useful applications of this is to determine how many entries there are in a FASTA file.

> Run the code block below to use grep to count the number of sequences in a FASTA file:

```bash

grep -c '>' data1/test.fa
## grep: The Unix string search command
## -c: An option the tells grep to simply count the number of lines that contain the provided string
## '>': The string to search for in the provided file

```

`grep -v` *inverts* grep, printing every line that does NOT match the pattern. E.g. we want to pull out just the sequences from a FASTA file and not the headers.

> **Exercise**:
> Write a command to use grep to print out only the lines that contain sequence and not the headers in the FASTA file. Then record the working code in the code block below.

```bash

### Use grep to display only sequence lines (EXCLUDE header lines)
## data1/test.fa
grep -v '>' data1/test.fa

```

There are also several options that display not only the line that contains the matching string, but the lines before and/or after it:

- `grep -B [n]` returns matching line and n lines *before* match
- `grep -A [n]` returns matching line and n lines *after* match
- `grep -C [n]` returns matching line and n lines *before and after* match

We can use `grep -A` to pull out both the header and the sequence for a particular entry of interest (assuming that the FASTA file is single-line and not multi-line!).

> Run the code below to print both the headers that contain a certain string as well as the sequences (since this is not a multi-line FASTA file):

```bash

grep -A 1 '>chr1' data1/test.fa
## grep: The Unix string search command
## -A 1: An option the tells grep to display the line right after each line that contains the provided string as well as the line with the match
## '>chr1': The string to search for in the provided file

```

Note that this is actually pulling out **two** entries, due to the partial matching of the pattern we used. To get around this problem, we can use `grep -w`, which forces `grep` to match *entire words*, in combination with the -A argument.

> Run the code below to print both the headers that contain an exact match of a certain string as well as the sequences (since this is not a multi-line FASTA file):

```bash

grep -A 1 -w '>chr1' data1/test.fa
## grep: The Unix string search command
## -A 1: An option the tells grep to display the line right after each line that contains the provided string as well as the line with the match
## -w: This option tells grep to only print lines that EXACTLY match the provided string
## '>chr1': The string to search for in the provided file

```

> **Exercise**:
>
> Write a grep command that searches for a particular sequence motif in our FASTA file and prints the whole line containing that sequence as well as the sequence header associated with that sequence. Remember that the FASTA sequence is not multi-line.
> Search for the following sequence motif: GGGTCGTCGT
> When finished, copy the working code to the code block below.

```bash

### Write a grep command to search for a sequence motif and display the matched sequence and the header
## data1/test.fa
grep -B 1 GGGTCGTCGT data1/test.fa


```

The last argument we will discuss is `grep -f patterns.txt`, which has slightly different syntax. This takes a text file of patterns (with a single pattern per line) and prints every line that matches each pattern in the file, which is useful if you have multiple patterns!\
There are numerous ways to make the text file. One option is using a *text editor* program that is built into the command line called `nano`. Think of it like TextEdit on a Mac, but more barebones and no graphical user interface.  

To create a text file, type `nano nameOfFile.txt`. This will open up a sub-window where you can type freely. At the bottom of the screen are a list of keyboard shortcuts with various functions; the most important is `^X`, i.e. `Control+X`, which prompts you to save your work and closes the window.  

> Let's make our text file with patterns to match! Run the code below to generate a file containing a set of strings to search for:

```bash

nano matches.txt
## nano: A Unix command to open a text file, which we called matches.txt

## 1. Type >chr2, hit 'Enter', then type >Chr3  
## 2. Press Control+X to save and close the window

cat matches.txt
## Display the contents of the new file to the screen

```

You should see the following text:

```
>chr2
>Chr3
```

> Run the code below to search for lines in our FASTA file that contain any of a set of strings in a provided file:

```bash

grep -f matches.txt data1/test.fa
## grep: The Unix string search command
## -f: This option tells grep to read each line in the following file and search for lines in the provided file that contain any of the strings

```

### Regular expressions

One last way that we can modify how `grep` behaves is with *regular expressions*, a.k.a *regex*. Regex are patterns that describe a *set of strings*. In other words, they allow you to match complex patterns with `grep` (and other Unix commands), not just exact matches! Regex are extremely powerful and customizable, but can get very complicated, so we will just go over a few that are especially useful.

-   `^` matches pattern at start of string
-   `$` matches pattern at end of string
-   `.` matches any character (except a newline)
-   `[ ]` matches any of enclosed characters. Can use in conjunction with 'A-Z' or '0-9', i.e.:
    -   `[A-Za-z]` matches any alphabetical character, upper or lower case
    -   `[0-9]` matches any numeric character

So a more careful way to count the number of entries in a FASTA file would be by matching all the lines that start with a `>` character.

> Run the code below to search for FASTA sequence headers:

```bash

grep -c '^>' data1/test.fa
## grep: The Unix string search command
## '^>': The string to search for in the provided file with ^ being the regular expression that matches the beginning of a line in a file

```

(Technically there shouldn't be any `>` characters outside the start of the headers so you wouldn't need the `^`, but it is good to be thorough!)

> **Exercise**:
> Write a grep command with regular expression to find all of the lines in our **FASTA** file that end with a number. Then copy the working code to the code block below.

```bash

### Use grep and regex to display lines in the FASTA file that end with a number
## data1/test.fa
grep '[0-9]$' data1/test.fa


```

#### A quick aside about quotes:  

A common point of confusion when running commands in the `bash` shell is whether to use single quote marks `'` or double quotes `"`. You might find that sometimes it doesn't seem to matter and the command will work both ways, but other times the command will not work as expected or will give an error.  

The main difference is that using double quotes `"` in the shell will **expand** a variable, while single quotes `'` will not! Let's look in the case of `grep` what happens when we use single quotes vs double quotes around our pattern:  

```bash
#This defines a shell variable VAR to the string "hello world"
VAR="hello world"

#This command will look for the literal string $VAR in the file
grep '$VAR' file.txt 

#This command will look for the VALUE of the variable, "hello world"
#I.e. it expands that variable
grep "$VAR" file.txt
```

This will become more relevant in later workshops when we talk about shell variables, but for now just keep it in mind. Also note that this is true for ALL commands in the `bash` shell, not just `grep`! 
 
One final note: you might have even noticed that with `grep`, technically you don't even need to put quote marks around your pattern at all, and it will still return a match. This will work if the pattern is a *single word*...however, if there is white space or you are using a regex pattern , it will not! E.g.

```bash
#This will look for the pattern "hello" in the files world and file.txt
#I.e. it thinks "world" is a file and not part of the pattern
grep hello world file.txt
```

### `grep` practice

Let's take a look at a FASTA file that more closely matches one that you might encounter in the wild. The file `data1/dmel-all-chromosome-r6.50.simple.fasta` is the *Drosophila melanogaster* genome assembly, though a simplified version in order to save space in our github repository :). We'll use this for the following exercises.

> Run the following code just to get a look at the top of this file:

```bash

head data1/dmel-all-chromosome-r6.50.simple.fasta 
## head: a Unix command to display the first 10 lines of the provided file

```

So you can see an actual FASTA file may be a lot more complicated than our test one. The header contains a lot of information, and the sequence is very long. Importantly, note that the sequences are *on a single line*, which is important if we do something like counting sequences.

> **Exercise**: 
> Use `grep` to pull out headers corresponding to 'Unmapped_Scaffold's. Then copy the working code to the code block below.

```bash

### Use grep to display all "Unmapped_Scaffold"s
## data1/dmel-all-chromosome-r6.50.simple.fasta 
grep 'Unmapped_Scaffold' data1/dmel-all-chromosome-r6.50.simple.fasta 

```

> **Exercise**:
> Use `grep` to make sure that the FASTA file contains the same amount of headers and sequences lines. There a few ways you could do this, but it will take more than one command! Write all the different ways you found to the code block below.

```bash

### Count the number of lines that contain sequences and lines that are headers
## data1/dmel-all-chromosome-r6.50.simple.fasta
grep -c '>' data1/dmel-all-chromosome-r6.50.simple.fasta
grep -c -v '>' data1/dmel-all-chromosome-r6.50.simple.fasta

```

> **Exercise**:
> Use `grep` to pull out the header and sequence line for the chromosome `2R` and *only* 2R. Write your answer in the code block below. 

```bash

### Write a command to display the header and sequence for chromosome 2R
## data1/dmel-all-chromosome-r6.50.simple.fasta
grep -A1 -w '^>2R' data1/dmel-all-chromosome-r6.50.simple.fasta

```

> **Exercise**:
> Use `grep` to count the number of sequences that end with the pattern 'TATTC_', where the _ can be any other nucleotide.
> BONUS: Also find out the names of the scaffolds for these sequences.

```bash

### Write a command to count the number of sequences that end with TATTC_, where _ can be any other nucleotide
## data1/dmel-all-chromosome-r6.50.simple.fasta
grep -c 'TATTC[ATGC]$' data1/dmel-all-chromosome-r6.50.simple.fasta
grep -c 'TATTC.$' data1/dmel-all-chromosome-r6.50.simple.fasta
grep -c 'TATTC[A-Z]$' data1/dmel-all-chromosome-r6.50.simple.fasta

### BONUS: Write a command to also find out the names of the scaffolds of these sequences
grep -B1 'TATTC[ATGC]$' data1/dmel-all-chromosome-r6.50.simple.fasta

```

### FASTQ files

The other type of sequence file format we will discuss is FASTQ, which as the name suggests, is similar to FASTA format but also contains **q**uality information about the sequence. You will commonly encounter FASTQ files when working with sequencing pipelines, as second generation technologies like Illumina as well as 3rd generation technologies like PacBio and Nanopore output their data in this format. Each entry is comprised of *four* lines, as opposed to the two of FASTA:

-   *Header line* which starts with an `@` symbol and contains the sequence ID
-   *Sequence line* comprised of nucleotides\
-   *Spacer line* which is just a `+` character (an optionally the sequence ID again)\
-   *Quality line* which is a string of ASCII characters, each character corresponding to a base in the nucleotide sequence

Let's look at an example file.

> Run the code below to view the first few lines of a FASTQ file:

```bash

head -n 8 data1/test.fq
## head: a Unix command to display the first few lines of the provided file
## -n 8: This option tells head to only display the first 8 lines of the file

```

Here we see two sequences, `@ERR1013163.116808442/1` and `@ERR1013163.116808442/2`, which based on these IDs are probably to ends of a paired-end sequence read. The line directly following the header contains the familiar ATCG nucleotide symbols, and then there is a line with a `+`, simply meant to provide some space. Next, we see a line with seemingly random characters.

These characters correspond to the *Phred quality score* of the base at the same position in the sequence string. So the first quality score of the first sequence, `7`, matches with the first base in the sequence string, `T`, and so on. The **quality score** is actually a numerical value encoded as a single character and is expressed by a *Q score*. These reflect the probability that that base is accurate. Q scores are calculated by:

Q = -10 * log10(P)

where P = the error calling probability for that base. In short, *a higher Q score == a higher confidence call*, e.g. Q10 = 90% base call accuracy, Q30 = 99.9% accuracy, etc. To get its corresponding symbol, add +33 to the Q score to get the ASCII code and take the symbol that corresponds to that code; e.g. Q10 == `+`, Q30 == `?`. For reference, [here :octicons-link-external-24:](https://en.wikipedia.org/wiki/FASTQ_format#Encoding){:target="_blank"} is a table that lists Q scores and their corresponding ASCII codes and values. Most programs that handle FASTQ files translate these symbols for you, so don't worry about having to convert back and forth manually!

Let's take a look at parsing **FASTQ** files for information. We can try to use `grep` to count the number of entries in the file, remembering that header lines start with `@` and not `>`.

> Run the code block below to count the number of times the `@` symbol appears in the FASTQ file:

```bash

grep -c '^@' data1/test.fq
## grep: The Unix string search command
## -c: This option tells grep to simply count the number of lines that contain the provided string, rather than display the lines
## '^@': The string to search for in the provided file with ^ being the regular expression that matches the beginning of a line in a file

```

However, this is technically not a reliable way to do it! If we were to look at the table of ASCII quality scores, we can see that `@` is actually a permitted value in the quality line (corresponding to a Q score of 31). Granted, we would have to be unlucky enough to have the first base in the sequence to have a Q31 score, but with large datasets it is possible that it would skew our results. 

To reliably count the entries in our file, let's look at our next bioinformatic tool, `awk`.

### AWK

Invented in the 1970's, `awk` is a scripting language included in Unix-like operating systems. It specializes in one-liner programs and manipulating text files, and like most scripting languages it is also capable of various mathematical and logical operations.

In many cases, if you're parsing information from a text file, you could write a Python script... or you could do it with `awk` in a single line! This is intended just as a quick introduction to `awk`, we will go into more details in later workshops when we talk about interval files, where the power of `awk` really shines.

#### Syntax

`awk` scripts are organized as:

```
awk 'pattern { action; other action }' filename
```

Meaning that every time that the pattern is *true*, awk will execute the action in the brackets. By default, if no pattern is specified it matches every line in the input file, so the action will be taken every line, e.g. the following command:

```bash

awk '{print}' data1/test.fa
## awk: A command line scripting language command
## '' : Within the single quotes is the user defined script for awk to run on the provided file

```

Because we did not specify any pattern, the `print` action will execute every line of the file.

Similarly, if a *pattern* is specified without an *action*, the default action is `{print}`. This is useful to concisely select lines from a file where the *pattern* expression evaluates to true, and is similar in function to `grep`.

For our purposes today, the two most important patterns for our purposes are `BEGIN` and `END`, which tell the action to take place before any lines are read and after the last line.

`awk` has several built-in variables that are very useful for parsing text. We'll use more of these variables in a later workshop when we talk about interval files, but for now let's focus one variable called `NR`. `NR` refers to *'Number of Records'* in our file. By default, *a record refers to a single line of the file*, so `NR` is the number of lines seen so far in the program, or a count of the total number of lines in the file if evaluated in an action that matches the `END` pattern.

Going back to our original question, we know that each entry in a FASTQ file has four lines! To count how many sequences are in our dataset, we can combine the `NR` variable and the `END` pattern with some basic division. Try running the following:

```bash

awk 'END{print NR / 4}' data1/test.fq
## awk: A command line scripting language command
## '' : Within the single quotes is the user defined script for awk to run on the provided file

```
This example scratches the surface of what can be done with `awk`. For a good reference for additional one-line `awk` commands for doing frequently performed operations, check out [awk one liners :octicons-link-external-24:](https://www.pement.org/awk/awk1line.txt){:target="_blank"}.


## ALIGNMENT FILES

Let's move on to the next step of our "pipeline." Once we have our sequence files, a next step would typically be to map them against a reference genome. This could be in the form of mapping RNAseq reads to calculate differential expression, mapping genomic DNA from a population to call variants, or numerous other applications. There are a number of different programs for mapping (e.g. [BWA :octicons-link-external-24:](https://github.com/lh3/bwa){:target="_blank"}, [STAR :octicons-link-external-24:](https://github.com/alexdobin/STAR){:target="_blank"}, [minimap2 :octicons-link-external-24:](https://github.com/lh3/minimap2){:target="_blank"}) and which you choose will vary based on your data type and experimental design, but the alignment file created will likely be interchangeable.

### Intro to SAM/BAM format

SAM (Sequence Alignment/Map) format is one of the most common file formats produced by many different pieces of alignment software, both for long and short read sequence data. It is a tab delineated text file, with 11 mandatory fields, or columns, (listed below), plus header lines denoted with an `@` at the start of the line.

SAM files are human readable, but can be quite large. An alternate format is the Binary Alignment/Map (BAM) file, which is binary compressed and not human readable, but is more compact and efficient to work with. Most pipelines will use BAM format over SAM.

Let's take a look at a SAM file. We could use the typical bash commands like `cat` or `less` to view it, but there is a better way. Namely using our next bioinformatic tool, `samtools`!

### SAMtools

[SAMtools :octicons-link-external-24:](http://www.htslib.org/doc/samtools.html){:target="_blank"} is a suite of programs that are extremely useful for processing mapped reads and for downstream analysis. As stated above, SAM/BAM files from different programs are (mostly) interchangeable, so `samtools` will work with a file SAM/BAM file no matter what program produced it. It has a ton of functions (which you can check out on the [manual page :octicons-link-external-24:](http://www.htslib.org/doc/samtools.html){:target="_blank"}), but we will go through several of the most common uses.

#### samtools view

As the name suggests, this command lets you view the content of a SAM **or** BAM file (whereas if you tried opening a BAM file with something like `less`, it would be unreadable). Let's take a look at a file.

> Run the code below to display a few lines of a **SAM** file to the screen:

```bash

samtools view data1/file.sam | head -n 5
## samtools: A suite of programs to process SAM/BAM files
## view: The sub-program of samtools to execute
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
## -n 5: This option tells head to only display the first 5 lines of the file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

**A quick note on pipes**: in the above command you'll see the `|` character, which is a *pipe*. This is a part of the bash command line, and allows output from one command to be passed directly into a subsequent command as input. These can be chained together, passing input between a whole string of commands! This is especially useful with `samtools`, as the commands are designed to feed into one another and pipes will cut down on the number of intermediate files created.\
We will look at creating efficient pipelines more in depth in a later workshop. In this case however, we are just passing the output to the `head` command to view the first several lines.

As stated above, our file is tab-separated with 11 columns, plus a series of optional tags containing information about the sequence.

| **Column** | **Description**                        |
|------------|----------------------------------------|
| 1          | Read name                              |
| 2          | Bitwise flag                           |
| 3          | Reference name                         |
| 4          | Leftmost mapping position              |
| 5          | MAPQ quality score                     |
| 6          | CIGAR string                           |
| 7          | Name of 2nd read in pair               |
| 8          | Position of 2nd read in pair           |
| 9          | Length of mapping segment              |
| 10         | Sequence of segment                    |
| 11         | Phred33 quality score at each position |

SAM/BAM files can be intimidating to look at as they are very dense in information, so let's focus in on a few important parts.

#### SAM flags

The second column in a BAM/SAM file is the *bitwise flag*. The flag value is an integer, which is the sum of a series of decimal values that give information about how a read is mapped.

| **Integer** | **Description**                |
|-------------|--------------------------------|
| 1           | read is paired                 |
| 2           | read mapped in proper pair     |
| 4           | read unmapped                  |
| 8           | mate is unmapped               |
| 16          | read on reverse strand         |
| 32          | mate on reverse strand         |
| 64          | first read in pair             |
| 128         | second read in pair            |
| 256         | not primary alignment          |
| 512         | alignment fails quality checks |
| 1024        | PCR or optical duplicate       |
| 2048        | supplementary alignment        |

So e.g., for a paired-end mapping data set, a flag = **99** (1+2+32+64) means the read is mapped along with its mate (1 and 2) and in the proper orientation (32 and 64). Don't worry about memorizing these, there are plenty of tools online that decode these flags for you, such as right [here :octicons-link-external-24:](https://broadinstitute.github.io/picard/explain-flags.html){:target="_blank"}.

#### Filtering reads

While you don't need to know all the SAM flags, if there is one flag that is useful to have memorized it is **4**, which means the read is **unmapped**. Unmapped reads are most often filtered out, as many programs used in downstream analysis of SAM/BAM files only want mapped reads (and also to save space on disk!). You can filter reads containing a given flag using the `-f` (only take reads that match given flags) and `-F` (only take reads that do **NOT** match given flag) options in `samtools view`.

> Run the code below to remove unmapped reads from the **SAM** file and display the first few reads retained:

```bash

samtools view -F 4 data1/file.sam | head
## samtools: A suite of programs to process SAM/BAM files
## view: The sub-program of samtools to execute
## -F 4: This option tells samtools to filter any reads with the "4" flag
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

This removes any read that contains the 4 flag (e.g. 77, 141, etc.). You can filter on any other criteria using flags as well, e.g. only gets reads that map in proper pair:

```
samtools view -f 2 -h data1/file.sam
```

Note this uses `-f`, not `-F`, which **RETAINS** reads with those flags rather than filtering them!

> **Exercise**:
> Count how many reads in the SAM file are mapped in their proper pairs vs not proper pairs? Hint: remember, we can `pipe` to `wc -l` with `|` to count the number of lines of a file! Write your answer in the code block below.

```bash

### Write two commands to count the number of reads in the file that are properly paired and those that are not properly paired
## data1/file.sam
samtools view -f 2 data1/file.sam | wc -l
samtools view -F 2 data1/file.sam | wc -l

```

#### Converting between SAM/BAM

Remember that **SAM** files are plain-text tab-delimited files that can be easily read. However, they can be huge and take up a lot of space on our servers, so a compressed version is used, called **BAM** files.

By default `samtools view` outputs in SAM format, so converting from **BAM** to **SAM** is as easy as running 

```
samtools view -h -o outfile.sam file.bam
```

For converting SAM to BAM, we can still use `samtools view` but also include the `-b` option.

> Run the code below to convert samtools view output to **BAM** format and save it to a file:

```bash

samtools view -b -h -o file.bam data1/file.sam
## samtools: A suite of programs to process SAM/BAM files
## view: The sub-program of samtools to execute
## -b: This option tells samtools view to convert the output to BAM format
## -h: Retain the header lines in the input SAM/BAM file in the output
## -o: This option tells samtools view to print the output to the provided file rather than to the screen

ls -l file.bam
## List the info for the BAM file we created to confirm it exists

```

#### Headers

Note the use of the `-h` argument in the command above. As a reminder, in addition to the 11 tab separated fields, SAM files also contain **header** lines that start with `@` and describe information about the sequences found in the file. The `-h` argument adds a header, which many programs require to recognize a SAM/BAM file as properly formatted. Remember to include it!

Let's see what adding the `-h` argument does, looking at the BAM file we just created.

> Run the code below to display the first few lines of the **BAM** file to the screen

```bash

samtools view -h file.bam | head -n15
## samtools: A suite of programs to process SAM/BAM files
## view: The sub-program of samtools to execute
## -h: Retain the header lines in the input SAM/BAM file in the output
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
## -n 15: This option tells head to only display the first 15 lines of the file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

We can see the files starts with a series of lines starting with `@`, meaning the header was properly added. Now let's omit the `-h` and see what happens.

> Run the code below to view the first few lines of the BAM file without the header:

```bash

samtools view file.bam | head -n15
## samtools: A suite of programs to process SAM/BAM files
## view: The sub-program of samtools to execute
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
## -n 15: This option tells head to only display the first 15 lines of the file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

Note that if we don't specify that we want to print the header, `samtools view` will omit it!

> **Exercise**:
> Use `samtools view` to display ONLY the header of the **BAM** file (Hint: Read the help menu or man page of `samtools view`!). Copy your working code to the code block below.

```bash

### Use samtools view to display ONLY the header of the BAM file
## file.bam
samtools view -H file.bam

```

#### Sorting and indexing a BAM file

Many functions of `samtools`, as well as many programs that do downstream analysis on BAM files, require that your BAM file be sorted by sequence (e.g. chromosome, if mapping to an assembly) and position, and also indexed to be searchable. We can accomplish both of these using two other functions of `samtools`, `sort` and `index`. Their syntax is as follows.

> Run the code below to create a sorted **BAM** file from our original, and then indexes the sorted file.

```bash

samtools sort -o file.sorted.bam file.bam
## samtools: A suite of programs to process SAM/BAM files
## sort: The sub-program of samtools to execute
## -o: This option tells samtools view to print the output to the provided file rather than to the screen

ls -l file.sorted.bam
## List the info for the BAM file we created to confirm it exists

samtools index file.sorted.bam
## samtools: A suite of programs to process SAM/BAM files
## index: The sub-program of samtools to execute

ls -l file.sorted.bam.bai
## List the info for the index file we created to confirm it exists

```

For the `sort`, the `-o` argument gives the name of the desired output file. For `index`, we only have to provide the name of the BAM file we want to index and it will automatically create an output file with the same name as the input plus the `.bai` suffix, indicating that it is the corresponding index.

> PRACTICE: Putting it all together!

That was a lot of info! Let's take everything that we have learned and organize it into what a typical workflow might look like. Assume that we have already aligned the data and the aligner we used outputs the alignment file in SAM format. We want to go from our initial SAM file and end up with a *sorted, indexed BAM file with only the mapped reads retained*. Try inputting the commands yourself, then we will walk through it together.

> **Exercise**:
>
> 1. Convert the `data1/file.sam` **SAM** file to **BAM** format while retaining the header and removing unmapped reads, then sort the file. Call the new file `file.mapped.sorted.bam`.
>
> Hint: `samtools` commands can also make use of **pipes** (`|`) to avoid writing intermediate files!
> 2. Index the newly created sorted **BAM** file.
> Copy your working code to the code block below.


```bash

### Convert to BAM with header and without unmapped reads and then sort
## data1/file.sam
samtools view -h -b -F 4 data1/file.sam | samtools sort -o file.mapped.sorted.bam 

ls -l file.mapped.sorted.bam
## List the info for the BAM file we created to confirm it exists

### Index the new BAM file
samtools index file.mapped.sorted.bam

ls -l file.mapped.sorted.bam.bai
## List the info for the index file we created to confirm it exists
```

You should see files named `file.mapped.sorted.bam` and `file.mapped.sorted.bam.bai`!

### Downstream analysis

Now that our BAM is sorted and indexed, we can begin pulling useful information out of it. Let's look at several applications, using some of SAMtools (many) other functions.

#### Subsetting specific regions

The third and fourth columns of a SAM/BAM file denote the name of the reference sequence and the starting position that the query sequence (i.e. the sequence from your FASTA/FASTQ file) maps to. By default `samtools view` prints all alignments, but you can specify a specific chromosome by adding the chromosome name at the end of the command.

> Run the following command to display only alignments from chromosome 2:

```bash

samtools view file.mapped.sorted.bam 2 | head
## samtools: A suite of programs to process SAM/BAM files
## view: The sub-program of samtools to execute
## 2: This tells samtools view to only display alignments from this region
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

This pulls out reads from the file that map to the chromosome named '2'. If we wanted to be even more specific, we can add coordinates of a sub-region on the chromosome, the syntax for which looks like this: `name:start-end`.

> **Exercise**:
> Write a command to display only regions that align to chromosome 2 from position 200 to position 1000. Pipe the output to head to cut down on screen output. Write your answer in the code block below.

```bash

### View only regions mapped to chromosome 2, position 200 to 1000. Pipe to head.
## file.mapped.sorted.bam
samtools view file.mapped.sorted.bam 2:200-1000 | head

### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

#### Calculating coverage

One of the most common things you will want to know about your mapped reads is their coverage and depth, as this can impact your confidence in the assembly, the validity of your SNP calls, etc. "Coverage" is defined as the percentage of positions that have *at least one base aligned to it* (think of it as how much sequence is covered by mapped reads), while "depth" can be thought of as the redundancy of coverage (i.e. how many bases are aligned to a particular sequence). There are many approaches you can take to calculate coverage and depth, several of which you can do with SAMtools.

`samtools coverage`: for each contig/scaffold in the BAM/SAM file, outputs several useful summary stats as a table.

> Run the code below to calculate coverage in the **BAM** file:

```bash

samtools coverage file.mapped.sorted.bam
## samtools: A suite of programs to process SAM/BAM files
## coverage: The sub-program of samtools to execute

```

Like with `samtools view`, can also specify coordinates, although (annoyingly) the syntax is slightly different, in that you have to specify the `-r` option before the region.

> **Exercise**:
> Write a command calculate coverage only of regions that align to chromosome 2 from position 200 to position 1000. Don't forget -r here! Copy your working code to the code block below.

```bash

### Use the -r option with samtools coverage to display coverage info only for chromosome 2, positions 200 to 1000
## file.mapped.sorted.bam
samtools coverage file.mapped.sorted.bam -r 2:200-1000


```

As a quick way to visualize coverage, you can use the `-m` option create a histogram of coverage over a contig.

> Run the code below to calculate coverage for a region and display a text-based histogram:

```bash

samtools coverage -m file.mapped.sorted.bam -r 1:1-1000
## samtools: A suite of programs to process SAM/BAM files
## coverage: The sub-program of samtools to execute
## -m: This option tells samtools coverage to display a text histogram, rather than a table

```

This is a useful first-pass analysis or sanity check. However, a more thorough way to evaluate coverage is to look at per-base coverage rather than the average. For this you can use `samtools depth`.

> Run the code below to calculate per-base coverage for a given region of the **BAM** file:

```bash

samtools depth -a file.mapped.sorted.bam -r 1:1000-2000 | head
## samtools: A suite of programs to process SAM/BAM files
## depth: The sub-program of samtools to execute
## -a: This tells samtools depth to display information for every position, even if coverage is 0
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

This outputs a three column table, where the 1st column is the contig/scaffold/chromosome name, the 2nd is the position on that scaffold, and the 3rd is the depth (number of reads) over that base. This list is convenient for importing to programs like R, where you can plot e.g. a histogram showing the distribution of per-base depth, or distribution of depth over a contig.

#### Stats/flagstats

Another useful function built into SAMtools is `samtools stats`, which gives some quick summary statistics about your mapping reads. The amount of information it generates is somewhat overkill in most cases, so we will just look at the summary, with the help of our old friend `grep`.

> Run the code below to calculate stats on our **BAM** file and view only certain lines:

```bash

samtools stats file.mapped.sorted.bam | grep '^SN' | cut -f 2-
## samtools: A suite of programs to process SAM/BAM files
## stats: The sub-program of samtools to execute
## | : The Unix pipe operator to pass output from one command as input to another command
## grep: The Unix string search command
## '^SN': The string to search for in the provided file with ^ being the regular expression that matches the beginning of a line in a file

```

(`cut` is another command line tool. Don't worry too much about what it is doing here, but in short it is just trimming off a useless column at the start of the output)

### Other useful SAMtools tricks

#### Extracting a single sequence from a FASTA file

A common task you might want to do is to extract a single sequence from a **FASTA** file, e.g. you just want to work on a small test chromosome for a pilot analysis. Although we learned how to do this with `grep` earlier today, `samtools` also has a way to do this, using the `faidx` command. This command also creates an **index** of a **FASTA** file with the `.fai` extension. This index is required for many downstream analyses. However, if you provided with a region in the same format we've seen before (scaffold:start-end), it will also extract that sequence.

> **Exercise**:
> Use samtools faidx to extract the sequence from chromsome 2R of the Drosophila melanogaster genome, positions 200 to 300. Write your answer in the code block below.

```bash

### Extract chromsome 2R, positions 200 to 300 from D.mel genome
## data1/dmel-all-chromosome-r6.50.simple.fasta
samtools faidx data1/dmel-all-chromosome-r6.50.simple.fasta 2R:200-300

```

This is a very efficient way to extract sequences from a **FASTA** file (because `samtools` is very efficient!).

#### BAM to FASTQ/A

As SAM/BAM files contain both the sequence and the quality information for the aligned reads, it is very easy to convert back to sequence files! Just use `samtools fastq` or `samtools fasta`.

E.g. the following command will create a FASTQ file of only the mapped reads (as we are pulling from the BAM file where we filtered out the unmapped ones).

> Run the following code to convert the sequences in our **BAM** to **FASTQ** format and view only the first few lines of the output:

```bash

samtools fastq file.mapped.sorted.bam | head -n 12
## samtools: A suite of programs to process SAM/BAM files
## fastq: The sub-program of samtools to execute
## | : The Unix pipe operator to pass output from one command as input to another command
## head: a Unix command to display the first few lines of the provided file
## -n 12: This option tells head to only display the first 12 lines of the file
### NOTE: ignore the "Broken pipe" and "error closing standard output" errors! This is just an artifact of our setup for the workshop today.

```

#### Merge BAM files

You can combine multiple sorted BAM/SAM files, which can be useful if you have done multiple rounds of mapping:

```bash
samtools merge file.bam file2.bam ...
```

Unless otherwise specified, the headers will also be merged.

## End of Day 1

That's it for day 1! Join us tomorrow to learn about bed files and awk!

---

<!-- --------------------------------- -->
<!-- Page specfic CSS -->

<style type="text/css">

pre {
  overflow-x: scroll
}

pre code {
  white-space: pre;
}

/* This makes the output blocks scroll horizontally in HTML renders */

</style>
