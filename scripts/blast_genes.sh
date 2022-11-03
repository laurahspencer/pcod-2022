#!/bin/bash

#SBATCH --job-name=blast
#SBATCH --output=/home/lspencer/pcod-2022/sbatch/blast_gadMor.txt
#SBATCH --mail-user=laura.spencer@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 20
#SBATCH -t 21-0:0:0

# This script is for blasting the blue king crab coding sequences against
# the Uniqprot/Swissprot database

module load bio/blast/2.11.0+
module load bio/bedtools/2.29.2

BASE=/home/lspencer/references/gadMor3.0/GCF_902167405.1

# Extract sequences for just genes in fasta format
bedtools getfasta \
-fi ${BASE}/GCF_902167405.1_gadMor3.0_genomic.fa \
-bed ${BASE}/gadMor3.0_genes.bed \
-fo ${BASE}/gadMor3.0_genes.fasta

# Blast genes against uniprot/swissprot
blastx \
-query ${BASE}/gadMor3.0_genes.fasta \
-db /home/lspencer/references/blast/uniprot_sprot_20220111_protein \
-out ${BASE}/gadMor3.0_genes_blastx.tab \
-evalue 1E-5 \
-num_threads 20 \
-outfmt 6
