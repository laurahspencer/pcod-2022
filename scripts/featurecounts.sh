#!/bin/bash

#SBATCH --job-name=feature-counts
#SBATCH --output=/home/lspencer/pcod-2022/sbatch/featurecounts-20221107.txt
#SBATCH --mail-user=laura.spencer@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 20
#SBATCH -t 5-0:0:0

module load bio/subread/2.0.3
module load bio/samtools/1.11

IN=/home/lspencer/pcod-2022/aligned/star-gadmor
OUT=/home/lspencer/pcod-2022/aligned/star-gadmor/featurecounts
GTF=/home/lspencer/references/gadMor3.0/GCF_902167405.1

# Gene Counts
# Summarize paired-end reads and count fragments (instead of reads) which have both ends successfully aligned, i.e. don't count singletons, and don't count chimeras
# NOTE - I'm only counting reads that overlap with exons, then summarizing them at the gene level

featureCounts \
-p --countReadPairs \
-B \
-T 20 \
-C \
-t exon \
-g gene_id \
-a ${GTF}/genomic.gtf \
-o ${OUT}/featurecounts_gene \
${IN}/*.Aligned.sortedByCoord.out.bam

# Exon Counts
# Summarize paired-end reads and count fragments (instead of reads) which have both ends successfully aligned, i.e. don't count singletons, and don't count chimeras
# NOTE: I'm only counting reads that overlap with exons, and also summarizing them at the exon level (by specifying -f i'm summarizing at the "feature" level, i.e. exon)
featureCounts \
-p --countReadPairs \
-B \
-T 20 \
-C \
-t exon \
-f \
-a ${GTF}/genomic.gtf \
-o ${OUT}/featurecounts_exon \
${IN}/*.Aligned.sortedByCoord.out.bam
