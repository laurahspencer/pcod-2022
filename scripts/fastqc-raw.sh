#!/bin/bash

#SBATCH --job-name=pcod-fastqc
#SBATCH --output=/home/lspencer/pcod-2022/sbatch/20221014-fastqc.txt
#SBATCH --mail-user=laura.spencer@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 20
#SBATCH -t 1000

# This script is for running FastQC and MultiQC on raw (but I think trimmed)
# Pacific cod RNA-Seq data

# Data structure received from Novagene
# For each sample, there are 2 raw data files corresponding to R1 and R2,
# which are in their own directory entitled the sample number.

module load bio/fastqc/0.11.9
source /home/lspencer/venv/bin/activate

IN=/share/afsc/pcod-2022/usftp21.novogene.com/01.RawData
OUT=/share/afsc/pcod-2022/fastqc

# store sample names to variable
SAMPLES=$(ls ${IN})

# loop through sample names
for sample in ${SAMPLES}
do
  # run fastqc on each raw read file (two per sample for R1 and R2)
fastqc \
--threads 20 \
${IN}/${sample}/${sample}_1.fq.gz \
${IN}/${sample}/${sample}_2.fq.gz \
--outdir ${OUT}
done

# Run multiqc to summarize fastqc reports
multiqc \
${OUT} \
--outdir ${OUT}
