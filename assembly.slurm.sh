#!/bin/bash

## Genomics: quality assessment and assembly of next-generation sequencing data

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
#		fastqc: quality assessment, http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
#		velvet: genome assembler, https://www.ebi.ac.uk/~zerbino/velvet/
# testData.fastq, reference.fa, and genes.fa in genomics/data

# load modules pre-installed in Stampede
module load fastqc velvet

# create directory structure

# download data

# assess raw data for quality
fastqc testData.fastq

# assemble genome
velveth assembly 51 -fastq data/testDataTrim.fastq
velvetg assembly -cov_cutoff auto -exp_cov auto
