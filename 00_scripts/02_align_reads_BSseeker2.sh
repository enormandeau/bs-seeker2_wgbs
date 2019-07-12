#!/bin/bash

# 2 CPU
# 10 Go

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
REF="02_reference/genome.fasta" 			# Genomic reference .fasta
INDREF="02_reference/genome.fasta_bowtie2"		# Path to indexed reference directory
READS="04_trimmed_reads"
ALIGN="05_aligned_bam"
TEMP="99_tmp/"

# Modules
module load bowtie/2.3.4.1

# Align reads
for file in $(ls $READS/*.fq | perl -pe 's/R[12]\_val_[12]\.fq//g') #| grep -v '.md5') 
do
    base=$(basename $file)

    # Decompress files
    gunzip "$READS"/*fq.gz

    # Align
    time /home/clem/00_soft/BSseeker2/bs_seeker2-align.py --input_1="$READS"/"$base"R1_val_1.fq --input_2="$READS"/"$base"R2_val_2.fq \
        --genome=$REF --temp_dir="$TEMP" \
        --output="$ALIGN"/"$base".bam \
        --aligner=bowtie2 \
        --bt2-p 16 \
        --bt2--end-to-end \
        --mismatches=4 \
        --split_line=500000
        #--output-format=bam \
        #--db="$INDREF" \
        #--temp_dir="$TEMP" 

    # Cleanup
    rm <FASTQ FILE>
done

#rm -r "$TEMP"/bs_seeker2_"$ID"*
