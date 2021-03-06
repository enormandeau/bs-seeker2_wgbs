#!/bin/bash

# 1 CPU
# 12 Go

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"

# Global variables
REF="02_reference/genome.fasta"
INDREF="02_reference"

# Modules
module load bowtie/2.3.4.1

echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Index the reference with BSseeker2
bs_seeker2-build.py -f "$REF" --aligner=bowtie2 -d "$INDREF"
