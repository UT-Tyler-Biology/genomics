#!/bin/bash

## Genomics: mapping next-generation sequencing reads and variant call analysis

#SBATCH -J genomics	# Job name
#SBATCH -o genomics.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 2:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user EMAIL@someplace.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A UT-Tyler-Bioinformat	# Allocation name to charge job against

## USAGE: sbatch genomics.slurm
## DEPENDENCIES (already installed in Stampede): 
#		bwa: read mapping, http://bio-bwa.sourceforge.net
#		samtools: ngs manipulation, http://www.htslib.org
# testData.fastq, reference.fa, and genes.fa in genomics/data

# load modules pre-installed in Stampede
module load fastqc velvet bwa samtools

# set up directory structure

# download data

# index reference
bwa index reference.fa
samtools faidx reference.fa

# map reads to contigs
bwa mem -t 8 reference.fa ../data/testDataTrim.fastq > reference.sam

# convert sam to sorted bam format
samtools view -bS reference.sam | samtools sort - reference.sorted

# print simple summary statistics for read mapping
samtools flagstat reference.sorted.bam > ../results/reference.flagstat.txt

# add depth of coverage to summary file
samtools depth reference.sorted.bam | awk '{sum+=$3} END { print "Average coverage= ",sum/NR}' >> ../results/reference.flagstat.txt

# find SNPs in reads relative to reference
samtools mpileup -uf reference.fa reference.sorted.bam | $WORK/myapps/bcftools view - > var.raw.bcf
