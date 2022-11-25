# CRISPRT4



## What CRISPRT4 is made for

CRISPRT4 is a workflow to screen hundreds of potential T4 phage point mutants obtained from the CRISPR-Cas12 approach as described in Pozhydaieva et al., 2023 (LINK). It is designed only for screening of phage mutants via sequencing of distinct amplified genomic regions of interest with the Oxford Nanopore platform. This workflow includes demultiplexing with minibar, mapping to the reference genome with minimap2 and variant calling using longshot.

## Installation of requirements

For the data analysis, several tools which are most easily installed via miniconda. Therefore, it is recommended that you follow the suggested installation procedure described in the following:

1. Install miniconda via the command line following instructions presented on: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html

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

5. Install minimap2 (https://github.com/lh3/minimap2)
```
conda install -c bioconda minimap2
```

6. Install samtools (https://github.com/samtools/samtools)
```
conda install -c bioconda samtools
```

7. Install longshot (https://github.com/pjedge/longshot)
```
conda install -c bioconda longshot
```


## Perform analysis of your data

1. In your working directory execute the bash script "Create_path.sh" in order to 



***

## Authors and acknowledgment
To be added.

## Project status
This project is currently under development.
