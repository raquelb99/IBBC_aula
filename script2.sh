#!/bin/bash

# Define directories for input and output
BASE_DIR="$HOME/Project"
INPUT_DIR="${BASE_DIR}/raw_data"
FQCOUTPUT_DIR="${BASE_DIR}/fastqc/fastqc_intermediate"
PFQCOUTPUT_DIR="${BASE_DIR}/fastqc/fastqc_results"
MQCOUTPUT_DIR="${BASE_DIR}/multiqc/multiqc_fastqc_results"
CMQCOUTPUT_DIR="${BASE_DIR}/multiqc/multiqc_clean_results"
FPOUTPUT_DIR="${BASE_DIR}/fastp"
ORGOUTPUT_DIR="${BASE_DIR}/getorganelles"
LOG_DIR="${BASE_DIR}/logs"

# Log file for the script
SCRIPT_LOG="$LOG_DIR/script_log.txt"

# Loop through all pairs of fastq files in the input directory
for R1_FILE in $INPUT_DIR/*_R1.fastq.gz; do
    # Get the base name of the R1 file
    SAMPLE_NAME=$(basename $R1_FILE _R1.fastq.gz)

    # Define the corresponding R2 file
    R2_FILE="${INPUT_DIR}/${SAMPLE_NAME}_R2.fastq.gz"

    # Check if both R1 and R2 files exist
    if [[ -f $R1_FILE && -f $R2_FILE ]]; then
        echo "Processing sample: $SAMPLE_NAME" | tee -a $SCRIPT_LOG

        # Step 1: Run FastQC on original fastq files (in background)
        echo "Running FastQC on original files for sample $SAMPLE_NAME..." | tee -a $SCRIPT_LOG
        fastqc $R1_FILE $R2_FILE -o $FQCOUTPUT_DIR >> $LOG_DIR/${SAMPLE_NAME}_fastqc.log 2>&1 &
        wait
        echo -en "\007"

        # Step 2: Run MultiQC on FastQC results
        echo "Running MultiQC on original files for sample $SAMPLE_NAME..." | tee -a $SCRIPT_LOG
        multiqc $FQCOUTPUT_DIR/${SAMPLE_NAME}_R1_fastqc.html $FQCOUTPUT_DIR/${SAMPLE_NAME}_R2_fastqc.html -o $MQCOUTPUT_DIR >> $LOG_DIR/multiqc_original.log 2>&1 &
        wait
        echo -en "\007"

        # Step 3: Run FastP for quality trimming
        echo "Running FastP for trimming on sample $SAMPLE_NAME..." | tee -a $SCRIPT_LOG
        fastp -i $R1_FILE -I $R2_FILE \
              -o $FPOUTPUT_DIR/${SAMPLE_NAME}_fp_R1.fastq.gz -O $FPOUTPUT_DIR/${SAMPLE_NAME}_fp_R2.fastq.gz \
              -l 80 -q 20 -p -g -D --html $FPOUTPUT_DIR/${SAMPLE_NAME}_fp.html --failed_out $FPOUTPUT_DIR/${SAMPLE_NAME}_fp.txt \ >> $LOG_DIR/${SAMPLE_NAME}_fastp.log 2>&1 &
        wait
        echo -en "\007"

        # Step 4: Run FastQC on the trimmed fastq files
        fastqc $FPOUTPUT_DIR/${SAMPLE_NAME}_fp_R1.fastq.gz $FPOUTPUT_DIR/${SAMPLE_NAME}_fp_R2.fastq.gz -o $PFQCOUTPUT_DIR  \ >> $LOG_DIR/${SAMPLE_NAME}_fastqc_trimmed.log 2>&1 &
        wait
        echo -en "\007"

        # Step 5: Run MultiQC on trimmed FastQC results
        multiqc $PFQCOUTPUT_DIR/${SAMPLE_NAME}_fp_R1_fastqc.html $PFQCOUTPUT_DIR/${SAMPLE_NAME}_fp_R2_fastqc.html -o $CMQCOUTPUT_DIR  \ >> $LOG_DIR/${SAMPLE_NAME}_multiqc_trimmed.log 2>&1 &
        wait

        # Step 6: Activate conda env
        # Define the conda env
        CONDA_ENV="organelles"

        # Ativate Conda env
        source /home/fc64483xp/miniconda3/etc/profile.d/conda.sh || { echo "Error: Conda not found."; exit 1; }
        conda activate "$CONDA_ENV" || { echo "Error: Failed to activate Conda environment $CONDA_ENV."; exit 1; }

        # Step 7: Run get_organelle_from_reads.py to extract mtDNA
        get_organelle_from_reads.py -1 $FPOUTPUT_DIR/${SAMPLE_NAME}_fp_R1.fastq.gz \
                                    -2 $FPOUTPUT_DIR/${SAMPLE_NAME}_fp_R2.fastq.gz \
                                    -R 10 -k 21,45,65,85,105 -F animal_mt -t 8 \
                                    -s /home/fc64483xp/.GetOrganelle/SeedDatabase/SardinaMH329246.fasta \
                                    -o $ORGOUTPUT_DIR/mtDNA_${SAMPLE_NAME}

        echo "Completed processing sample: $SAMPLE_NAME"
        echo -en "\007"
    else
        echo "Skipping $SAMPLE_NAME: Pair files not found."
    fi
done
