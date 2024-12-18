FastQC, FastP, and MultiQC Data Processing Pipeline
This pipeline processes raw sequencing data using several bioinformatics tools: FastQC, FastP, and MultiQC, followed by GetOrganelle for extracting mtDNA. It includes the following steps:

1.FastQC analysis on the raw sequencing data
2.MultiQC report generation based on FastQC results
3.FastP for quality trimming of raw fastq files
4.FastQC analysis on the trimmed fastq files
5.MultiQC report generation on trimmed FastQC results
6.GetOrganelle for extracting mitochondrial DNA (mtDNA) sequences from the trimmed fastq files

Prerequisites
Software
-Conda: Make sure Conda is installed and accessible.
-FastQC: For quality control of fastq files.
-FastP: For fast and efficient quality trimming of fastq files.
-MultiQC: For aggregating and visualizing results from FastQC and FastP.
-GetOrganelle: For extracting mitochondrial DNA sequences.

Conda Environments
The script requires two Conda environments:
-tools_qc for FastQC, FastP, and MultiQC tools.
-organelles for the GetOrganelle tool.

To create these environments, use the following commands:
conda create -n tools_qc (and install fastqc fastp multiqc) 
conda create -n organelles (and install getorganelle)

Input Files
The raw sequencing data (paired .fastq.gz files) in expected to be in $HOME/examples directory. The files should follow the naming convention:
-SampleName_R1.fastq.gz (for the first read in a pair)
-SampleName_R2.fastq.gz (for the second read in a pair)

Modifications can be made to exceute paired and single reads simultaneously, or to use screens or GNU to optimize the speed of the processing.

Conclusion
This pipeline automates the process of quality control and trimming of sequencing data, followed by mitochondrial DNA extraction. It uses FastQC for quality assessment, FastP for trimming, and MultiQC for summarizing the results. The final step extracts mtDNA sequences using GetOrganelle.


