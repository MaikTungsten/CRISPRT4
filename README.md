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

8. Install bcftools for osx or linux
```
conda install -c bioconda bcftools
```

9. Install subread for osx or linux
```
conda install -c bioconda subread
```

10. Alternative for osx-arm64 systems
```
conda create -n CRISPRT4
conda activate CRISPRT4
conda config --env --set subdir osx-64
then, install all Intel based tools as described above
´´´


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

2.2 Now, you can perform the demultiplexing with minibar (here, minimal required commands for minibar is given; if you require any specifications, please navigate to the github repository https://github.com/calacademy-research/minibar)
```
cd CRISPRT4/Demultiplexing
./minibar.py -T -F IndexCombination_ONTrun_079.txt All_reads_ONTrun_079.fastq
```

3. Move demultiplexed files to the input folder CRISPRT4/input/fastq directory

4. Execute the script for mapping and variant calling of demultiplexed sequencing data
4.1 Define the name of your reference genome (in fasta format) and give the absolute path for it
in your input reference folder execute the pwd command
```
pwd
```
example: /Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference
Thus, your REFERENCE variable will be:
```
REFERENCE="/Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference/NC_000866-4.fasta"
```
4.2 Define the target region for variant calling (ideally the coordinates of the locus at which you performed mutagenesis)
Example for modA and modB genes: 
```
TargetRegion="NC_000866.4:11000-14000"
```
As you can see, it is important that the TargetRegion is exactly comprised of the exact ID of the reference genome provided in fasta format and that you give start and end position of the locus separated by ":".

4.3 These two changes have to be made in the script by the user. 
```
# Adjust this single line of code to specify the absolute path to the reference genome for mapping and variant calling
REFERENCE="/Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference/NC_000866-4.fasta"

...

# Specify the target region for variant calling. This is a string combining the reference genome id and the region indicated by numbers, for instance the following region for modA and modB genes
TargetRegion="NC_000866.4:11000-14000"
```

4.4 Execute the Script for mapping and variant calling.
Deposit the Script "Mapping_and_Variant-calling.sh" in the CRISPRT4 directory.
Located in that directory, execute the script:
```
bash Mapping_and_Variant-calling.sh
```

4.5 Thereby, you will obtain sam, bam and indexed bam files from the alignments (in CRISPRT4/output/alignment) as well as vcf files (in CRISPRT4/output/vcfFiles) indicating variants at the chosen locus. These files can be viewed with IGV or similar software.

5. Optional text based search for mutations
The Script "Screening_for_mutants_by_text-search.sh" is a quick and easy solution to screen for potential mutants without alignment. This script does only require demultiplexing prior to execution. This is how the code looks like at the example of screening for modA and modB mutants.
Here, chunks of the WT and the MUT sequence of the genes (including the mutated site of course) are given as input for text search via grep through the demultiplexed fastq files. In addition, a random gene sequence outside the mutation site is given. You should be aware that this will only identify a fraction of reads which actually correspond to the target gene, as Nanopore reads are quite noisy and mismatches are not tolerated in that search. However, mutants actually display low counts for WT sequence and vice versa and mutants are also identified as such by mapping and variant calling. Thus, this script provides a quick indication of potential mutants.

Here, you can see the script. For your genes of interest, edit the sequence names in the lines starting with "echo" and the corresponding sequence below.

```
cd CRISPRT4/input/fastq
for FILE in *.fastq
do
echo $FILE
wc -l $FILE
echo "ModB random"
grep -c 'ATCAGTTTTTAAACGAAGTA' $FILE
echo "ModB WT"
grep -c 'TATACCACGATATAATTGAT' $FILE
echo "ModB MUT"
grep -c 'TATACCGCGATATAATTGAT' $FILE
echo "ModA random"
grep -c 'ATAACTTGTGTGTTATACTC' $FILE
echo "ModA WT"
grep -c 'GATGAACAAGAAGTAATGAT' $FILE
echo "ModA MUT"
grep -c 'GATGAACAAGCGGTAATGAT' $FILE
echo "------------------------------------"
done
```

Then, locate the script in the CRISPRT4 directory and execute:
```
bash Screening_for_mutants_by_text-search.sh > Text_search_28-11-2022.txt
```

You will yield a file which may look like this:
```
sample_S124.fastq
616 sample_S124.fastq
ModB random
31
ModB WT
51
ModB MUT
0
ModA random
44
ModA WT
0
ModA MUT
54
------------------------------------
sample_S125.fastq
1924 sample_S125.fastq
ModB random
82
ModB WT
145
ModB MUT
1
ModA random
124
ModA WT
110
ModA MUT
0
```
You can see that S124 likely is a modA mutant.


***

## Authors and acknowledgment
To be added.

## Project status
This project is currently under development.
