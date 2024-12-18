#!/bin/bash

./directories.sh

BASE_DIR="$HOME/Project"
# ==========================
# Step 2: Copy raw data from a directory to raw_data directory
# ==========================
EXAMPLES_DIR="$HOME/examples"
SAMPLE_DIR="$BASE_DIR/raw_data"

# Check if the raw_data directory exists and is non-empty
if [ -d "$EXAMPLES_DIR" ]; then
  echo "Copying .fastq.gz files from $EXAMPLES_DIR to $SAMPLE_DIR..."
  cp "$EXAMPLES_DIR"/*.fastq.gz "$SAMPLE_DIR"
  echo "Successfully copied fastq.gz files from $EXAMPLES_DIR to $SAMPLE_DIR."
else
  echo "Error: $EXAMPLES_DIR does not exist. Please add your sample files and re-run"
  exit 1
fi

# =========================== #
#  Activate Conda Environment #
# =========================== #
# Define the conda env
CONDA_ENV="tools_qc"

# Ativate Conda env
source /home/fc64483xp/miniconda3/etc/profile.d/conda.sh || { echo "Error: Conda not found."; exit 1; }
conda activate "$CONDA_ENV" || { echo "Error: Failed to activate Conda environment $CONDA_ENV."; exit 1; }


./script2.sh

echo "        ><(((º>    "
echo "    ><(((º>   ><(((º> "
echo " ><(((º>  ><(((º>    "
echo
echo
echo " For further analysis visit:"
echo " https://mitofish.aori.u-tokyo.ac.jp/annotation/input/"
echo " https://rrwick.github.io/Bandage/ "
echo "      ___________ "
echo "     |           |"
echo "     |  O     O  |"
echo "     |     .     |"
echo "     |  O     O  |"
echo "     |___________|"
echo
echo 
