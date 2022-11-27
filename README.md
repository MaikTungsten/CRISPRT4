# CRISPRT4



## What CRISPRT4 is made for

CRISPRT4 is a workflow to screen hundreds of potential T4 phage point mutants obtained from the CRISPR-Cas12 approach as described in Pozhydaieva et al., 2023 (LINK). It is designed only for screening of phage mutants via sequencing of distinct amplified genomic regions of interest with the Oxford Nanopore platform. This workflow includes demultiplexing with minibar, mapping to the reference genome with minimap2 and variant calling using longshot.

## Installation of requirements

For the data analysis, several tools which are most easily installed via miniconda. Therefore, it is recommended that you follow the suggested installation procedure described in the following:

1. Install miniconda via the command line following instructions presented on: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html. Please consider that depending on your system the below described installations may need to be adjusted (e.g. Osx64 vs Osx-arm64 depending on the processor of your Mac).

2. Create a python environment (here named "CRISPRT4")
```
conda create -n CRISPRT4 python=3.9
```

3. Install the edlib package which is required for minibar
```
pip install edlib
```

4. Download minibar (https://github.com/calacademy-research/minibar) and allow execution
```
wget https://raw.githubusercontent.com/calacademy-research/minibar/master/minibar.py
chmod 775 minibar.py
```

5. Install minimap2 (https://github.com/lh3/minimap2) for osx64 and linux
```
conda install -c bioconda minimap2
```
or for osx-arm64
```
conda install -c jmeppley minimap2
```

6. Install samtools (https://github.com/samtools/samtools) for osx64 and linux
```
conda install -c bioconda samtools
```
or for osx-arm64
```
conda install -c merv samtools
```

7. Install longshot (https://github.com/pjedge/longshot) for osx or linux (unfortunately, not available for osx-arm64)
```
conda install -c bioconda longshot
```


## Perform analysis of your data

1. In your working directory execute the bash script "Create_path.sh" in order to create a directory network suitable for the downstream scripts
```
bash Create_path.sh
```

You should have yielded the following directory structure:
./CRISPRT4
./CRISPRT4/input
./CRISPRT4/input/fastq
./CRISPRT4/input/reference
./CRISPRT4/output
./CRISPRT4/output/alignment
./CRISPRT4/output/vcfFiles
./CRISPRT4/Demultiplexing

2. Data deposition and demultiplexing

2.1 Nanopore read output is often organized in little chunks of fastq files which correspond to a single experiment. Combine these files in a single file. You should deposit all chunked fastq files in the CRISPRT4/input/fastq directory and then combine them in one file by the following command executed in that directory:
```
cat CRISPRT4/input/fastq/*.fastq > CRISPRT4/input/fastq/All_reads.fastq
```
Move this file (Example: All_reads_ONTrun_079.fastq) to CRISPRT4/Demultiplexing and remove it from the CRISPRT4/input/fastq directory. Here, you should also deposit the IndexCombination file for minibar (Example: IndexCombination_ONTrun_079.txt) and the minibar script (minibar.py) which you have downloaded. 

2.2Now, you can perform the demultiplexing with minibar (here, minimal required commands for minibar is given; if you require any specifications, please navigate to the github repository https://github.com/calacademy-research/minibar)
```
cd CRISPRT4/Demultiplexing
./minibar.py -T -F IndexCombination_ONTrun_079.txt All_reads_ONTrun_079.fastq
```

3. Move demultiplexed files to the input folder CRISPRT4/input/fastq directory

4. Execute the script for mapping and variant calling of demultiplexed sequencing data
4.1 Define the name of your reference genome (in fasta format) and give the absolute path for it
```
in your input reference folder execute the pwd command
```
example: /Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference
Thus, your REFERENCE variable will be:
```
REFERENCE="/Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference/NC_000866-4.fasta"
```
4.2



***

## Authors and acknowledgment
To be added.

## Project status
This project is currently under development.
