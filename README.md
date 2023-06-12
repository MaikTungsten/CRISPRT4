# CRISPRT4



## What CRISPRT4 is made for

CRISPRT4 is a workflow to screen hundreds of potential T4 phage point mutants obtained from the CRISPR-Cas12 approach as described in Pozhydaieva et al., 2023 (**LINK**). It is designed only for screening of phage mutants via sequencing of distinct amplified genomic regions of interest with the Oxford Nanopore platform. This workflow includes demultiplexing with minibar, mapping to the reference genome with minimap2 and variant calling using longshot.

## Installation of requirements

For the data analysis, several tools are needed which are most easily installed via miniconda. Therefore, it is recommended that you follow the suggested installation procedure described in the following but different setups are certainly possible:

1. Install miniconda via the command line following instructions presented on: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html. Please consider that depending on your system the below described installations may need to be adjusted (e.g. Osx64 vs Osx-arm64 depending on the processor of your Mac).

2. Create a python environment (here named "CRISPRT4")
```
conda create -n CRISPRT4 python=3.9
```

3. Install the edlib package which is required for minibar
```
pip install edlib
```

4. Download minibar (https://github.com/calacademy-research/minibar) and allow its execution
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

10. Alternative for osx-arm64 systems for which certain packages are lacking
```
conda create -n CRISPRT4_2
conda activate CRISPRT4_2
conda config --env --set subdir osx-64
then, install all Intel based tools as described above (longshot, bcftools and subread from 7. - 9.)
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

2.2 Now, you can perform the demultiplexing with minibar (here, minimal required commands for minibar is given; if you require any specifications, please navigate to the github repository https://github.com/calacademy-research/minibar)
```
cd CRISPRT4/Demultiplexing
./minibar.py -T -F IndexCombination_ONTrun_079.txt All_reads_ONTrun_079.fastq
```
3. Move demultiplexed files to the input folder CRISPRT4/input/fastq directory

4. Deposit the required reference genome including an annotation, a fasta file and the index fai file in the CRISPRT4/input/reference directory

5. Execute the script for mapping and variant calling of demultiplexed sequencing data:
EITHER Mapping_and_Variant-calling_Intel.sh (for basically all systems, requires prior activation of CRISPRT4 environment) OR Mapping_M1.sh (for M1 chip systems, requires CRISPRT4 environment for M1) and Variant-calling_M1.sh (for M1 chip systems, requires CRISPRT4_2 environment for M1)

5.1 Define the name of your reference genome (in fasta format) and assign the absolute path for it
in your input reference folder execute the pwd command
```
pwd
```
example: /Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference
Thus, your REFERENCE and GFF3 variables will be:
```
REFERENCE="/Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference/NC_000866-4.fasta"
GFF3="/Users/maikschauerte/Data-Analysis/CRISPRT4/input/reference/NC_000866-4.gff3"
```
5.2 Define the target region for variant calling (ideally the coordinates of the locus at which you performed mutagenesis)
Example for modA and modB genes: 
```
TargetRegion="NC_000866.4:11000-14000"
```
As you can see, it is important that the TargetRegion is exactly comprised of the exact ID of the reference genome provided in fasta format and that you give start and end position of the locus separated by ":".

5.3 These two changes have to be made in the script by the user. 
```
# Adjust these lines of code to specify the absolute path to the reference genome for mapping and variant calling
REFERENCE="/Users/maikschauerte/Data-Analysis/NP_final/ONTrun_079/CRISPRT4/input/reference/NC_000866-4.fasta"
GFF3="/Users/maikschauerte/Data-Analysis/NP_final/ONTrun_079/CRISPRT4/input/reference/NC_000866-4.gff3"

...

# Specify the target region for variant calling. This is a string combining the reference genome id and the region indicated by numbers, for instance the following region for modA and modB genes
TargetRegion="NC_000866.4:11000-14000"
```

5.4 Execute the Script for mapping and variant calling.
Deposit the Script "Mapping_Variant-calling_Counting.sh" in the ./CRISPRT4 directory. For M1 Chip-based systems execute the script: Mapping_M1.sh and thereafter Variant-calling_M1.sh.
Located in that directory, execute the script such as in this example:
```
bash Mapping_and_Variant-calling.sh
```

5.5 Thereby, you will obtain sam, bam and indexed bam files from the alignments (in CRISPRT4/output/alignment) for inspection in genome browsers, vcf files (in CRISPRT4/output/vcfFiles) indicating variants at the chosen locus and read count data (in CRISPRT4/output/countData) showing how many reads were mapped to features of distinct genes. Vcf and bam files can be viewed with IGV or similar software. Counts table can be analysed in R or Python.

6. To obtain information from the vcf files in an easy to screen format, you can run the Screening_for_mutants_by_vcf_files.sh script.
This is a quick and easy solution to screen for potential mutants by extracting variant call information from each vcf files. Based on indicated sites with variants, you can then decide on which mutants to investigate further in IGV based on the alignments. Theoretically, you should not observe variants at sites other than the one mutated and for negative clones you should not observe any variants called by longshot. Thus, these samples appear without any information except for the sample name in the txt file.

Locate the script in the CRISPRT4 directory and execute:
```
bash Screening_for_mutants_by_vcf-files.sh > Vcf_summary.txt
```

You will yield a file which may look like this:
```
sample_S122_variants.vcf
------------------------------------
sample_S123_variants.vcf
------------------------------------
sample_S124_variants.vcf
NC_000866.4	12016	.	T	C	500.00	PASS	DP=150;AC=10,130;AM=10;MC=0;MF=0.000;MB=0.000;AQ=14.67;GM=1;DA=150;MQ10=1.00;MQ20=1.00;MQ30=1.00;MQ40=1.00;MQ50=1.00;PH=500.00,244.98,244.98,0.00;SC=GTATCATTACTTCTTGTTCAT;	GT:GQ:PS:UG:UQ	1/1:241.97:.:1/1:500.00
NC_000866.4	12017	.	T	G	500.00	PASS	DP=150;AC=1,136;AM=13;MC=0;MF=0.000;MB=0.000;AQ=13.34;GM=1;DA=150;MQ10=1.00;MQ20=1.00;MQ30=1.00;MQ40=1.00;MQ50=1.00;PH=500.00,397.71,397.71,0.00;SC=TATCATTACTTCTTGTTCATC;	GT:GQ:PS:UG:UQ	1/1:394.70:.:1/1:500.00
------------------------------------
sample_S125_variants.vcf
------------------------------------
```
The first column represents the reference genome ID, followed by the variant position, in the fourth column the expected base is shown and the alternative variant base in the subsequent column. You can see that S124 likely is a modA mutant which should be further investigated by looking at the alignments and verified by Sanger sequencing.


***

## Authors and acknowledgment
_To be added by N.P._ M.W. performed data analysis, documentation and created this repository.

## Project status
This project is currently under development.
