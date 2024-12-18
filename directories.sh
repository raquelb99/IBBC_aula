#!/bin/bash

# ==========================
# Data Analysis Directory Setup Script
# ==========================

# Define the base directory (home area of the user)
BASE_DIR="$HOME/Project"

# Fixed subdirectory structure
DEFAULT_SUBDIRS=(
  "raw_data"                        # Directory for raw datasets
  "fastqc"                          # Directory for FastQC analysis
  "fastqc/fastqc_results"           # Subdirectory for FastQC results
  "fastqc/fastqc_intermediate"      # Subdirectory for FastQC intermediate results
  "fastp"                           # Directory for Fastp analysis
  "getorganelles"                   # Directory for GetOrganelle analysis
  "multiqc"                         # Directory for MultiQC analysis
  "multiqc/multiqc_fastqc_results"  # Subdirectory for MultiQC FastQC results
  "multiqc/multiqc_clean_results"   # Subdirectory for MultiQC cleaned results
  "logs"                            # Directory for logs and metadata
)

# ==========================
# Step 1: Create Base and Subdirectories
# ==========================
for SUBDIR in "${DEFAULT_SUBDIRS[@]}"; do
  DIR="$BASE_DIR/$SUBDIR"
  if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
    echo "Created directory: $DIR"
  else
    echo "Directory already exists: $DIR"
fi
done
