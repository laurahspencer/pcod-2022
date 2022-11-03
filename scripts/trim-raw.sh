#!/bin/bash

#SBATCH --job-name=trim-pcod
#SBATCH --output=/home/lspencer/pcod-2022/sbatch/20221011-trim-pcod.txt
#SBATCH --mail-user=laura.spencer@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 8
#SBATCH -t 5-0:0:0

# This script is for trimming raw RNA-Seq data and
# filtering for quality and length.
# It has been slightly adapted from code written by Giles Goetz

source /home/lspencer/venv/bin/activate  #activate env with cutadapt

IN=/share/afsc/pcod-2022/usftp21.novogene.com/01.RawData
OUT=/scratch/lspencer/pcod-2022/trimmed
FASTQC=/scratch/lspencer/pcod-2022/trimmed/fastqc

# store sample names to variable
SAMPLES=$(ls ${IN})

# loop through sample names
#for sample in ${SAMPLES}
#the first job timed out, so here I loop through the SAMPLES variable starting at the 280th character, sample PCG163 (probably a better way)
for sample in ${SAMPLES:280}
do
  echo "Trimming sample ${sample}"

    # Trimming the Illumina adapters
    # Quality-trim  5’ end with cutoff=15 & 3’ end with cutoff=10
    # Trimming out leftover N's
    # Trimming reads that countain N>10%
    # Filtering out sequences shorter then 50bp
    cutadapt \
        -o ${OUT}/${sample}.trimmed.R1.fastq.gz \
        -p ${OUT}/${sample}.trimmed.R2.fastq.gz \
        -a GATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
        -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        -q 15,10 \
        -m 50 \
        --trim-n \
        --max-n 0.1 \
        --cores=8 \
        ${IN}/${sample}/${sample}_1.fq.gz \
        ${IN}/${sample}/${sample}_2.fq.gz \
        &> ${OUT}/cutadapt.${sample}.log

# Run fastqc on trimmed data files
    fastqc \
        --threads 2 \
        -o ${FASTQC} \
        ${OUT}/${sample}.trimmed.R1.fastq.gz \
        ${OUT}/${sample}.trimmed.R2.fastq.gz \
        &> ${FASTQC}/fastqc.${sample}.log
done

# Run multiqc to summarize fastqc reports
multiqc \
${FASTQC} \
--outdir ${FASTQC}
