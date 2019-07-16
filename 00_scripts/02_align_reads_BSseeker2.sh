#!/bin/bash

# 4 CPU
# 20 Go

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
INDEXED_GENOME="02_reference"       # Path to indexed reference directory
TRIMMED_FOLDER="04_trimmed_reads"
ALIGNED_FOLDER="05_aligned_bam"
TEMP_FOLDER="99_tmp/"

# Modules
module load bowtie/2.3.4.1

# Align reads
for file in $(ls $TRIMMED_FOLDER/*.fastq.gz | perl -pe 's/_R[12].*//g' | sort -u) #| grep -v '.md5') 
do
    base=$(basename $file)

    # Decompress files
    gunzip -k "$TRIMMED_FOLDER"/"$base"_R1.fastq.gz
    gunzip -k "$TRIMMED_FOLDER"/"$base"_R2.fastq.gz

    # Align
    bs_seeker2-align.py \
        --input_1="$TRIMMED_FOLDER"/"$base"_R1.fastq \
        --input_2="$TRIMMED_FOLDER"/"$base"_R2.fastq \
        --genome=$GENOME \
        --db="$INDEXED_GENOME" \
        --temp_dir="$TEMP_FOLDER" \
        --output="$ALIGNED_FOLDER"/"$base".bam \
        --aligner=bowtie2 \
        --bt2-p 4 \
        --bt2--end-to-end \
        --mismatches=4 \
        --split_line=500000
        #--output-format=bam \
        #--temp_dir="$TEMP_FOLDER" 

    # Cleanup
    rm "$TRIMMED_FOLDER"/"$base"_R*.fastq
done

# Cleanup temp folder
rm -r "$TEMP_FOLDER"/*
