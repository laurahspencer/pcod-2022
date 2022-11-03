#!/bin/bash

#SBATCH --job-name=pcod-STAR
#SBATCH --output=/home/lspencer/pcod-2022/sbatch/20221014-align-STAR-gadmor.txt
#SBATCH --mail-user=laura.spencer@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 20
#SBATCH -t 30-0:0:0

module load aligners/star/2.7.10a

REF=/home/lspencer/references/gadMor3.0
IN=/scratch/lspencer/pcod-2022/trimmed
OUT=/home/lspencer/pcod-2022/aligned/star-gadmor

# ========= Build STAR genome index
# Use 20 threads, -runThreadN 20
# specify that I want to generate genome, --runMode genomeGenerate
# specify path to save STAR genome directory. Must already exist, --genomeDir
# specify path to genome, --genomeFastaFiles
# specify path to annotation file, --sjdbGTFfile
# specify length of the genomic sequence around the annotated junction to be used in constructing the splice junctions database.
#    Ideally, this length should be equal to the ReadLength-1, where ReadLength is the length of the reads.
#    My reads are 150bp, so I'll use 149 (Default is 100). --sjdbOverhang 149
# Got this warning when initially generating STAR genome files:
##   !!!!! WARNING: --genomeSAindexNbases 14 is too large for the genome size=669966409, which may cause seg-fault at the mapping step.
##     Re-run genome generation with recommended --genomeSAindexNbases 13
# So I added --genomeSAindexNbases 13 to the genome generate step
# removed this: #--limitGenomeGenerateRAM 601057045429 \

# STAR \
# --runThreadN 20 \
# --runMode genomeGenerate \
# --genomeDir ${REF}/STAR \
# --genomeFastaFiles ${REF}/GCF_902167405.1/GCF_902167405.1_gadMor3.0_genomic.fa \
# --sjdbGTFfile ${REF}/GCF_902167405.1/genomic.gtf \
# --genomeSAindexNbases 13 \
# --sjdbOverhang 149 \
# done

# ========= Run STAR alignment
# Use most of STAR's default settings, which include (but aren't limited to) ...
# Max number of multiple alignments is 10, if exceeded read is considered unmapped --outFilterMultimapNmax 10
# Min numer of bp overlap to assign read to a gene is 1nt
# Also ... count number of reads per gene while mapping, using --quantMode GeneCounts

# store sample names to variable
# sample names are easily obtained from the raw data directories
SAMPLES=$(ls /share/afsc/pcod-2022/usftp21.novogene.com/01.RawData)

# loop through sample names
#for sample in ${SAMPLES:35}  # if needed here is code to skip the first 34 characters in the variable 'samples' (e.g. if I already aligned 5 samples)
for sample in ${SAMPLES}
do
echo "Started mapping ${sample}"
STAR \
--runThreadN 20 \
--genomeDir ${REF}/STAR \
--readFilesIn ${IN}/${sample}.trimmed.R1.fastq.gz ${IN}/${sample}.trimmed.R2.fastq.gz \
--readFilesCommand gunzip -c \
--outFilterMultimapNmax 50 \
--outFileNamePrefix ${OUT}/${sample}. \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts \
--outReadsUnmapped Fastx \
&> ${OUT}/star-gadmor.${sample}.log
done
