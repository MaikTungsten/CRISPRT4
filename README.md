# CRISPRT4



## What CRISPRT4 is made for

CRISPRT4 is a workflow to screen hundreds of potential T4 phage point mutants obtained from the CRISPR-Cas12 approach as described in Pozhydaieva et al., 2023 (LINK). It is designed only for screening of phage mutants via sequencing of distinct amplified genomic regions of interest with the Oxford Nanopore platform. This workflow includes quality control of reads with pycoQC, demultiplexing with  mapping to the reference genome with minimap2 and variant calling using longshot.

## Installation of requirements

For the data analysis, several tools which are most easily installed via miniconda. Therefore, it is recommended that you follow the suggested installation procedure described in the following:

1. Install miniconda via the command line following instructions presented on: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html

2. Create a python environment (here named "CRISPRT4")
```
conda create -n CRISPRT4 python=3.7
```

3. Install the edlib package which is required for minibar
```
conda install -c bioconda edlib
```

4. Download minibar (https://github.com/calacademy-research/minibar) and allow execution
```
wget https://raw.githubusercontent.com/calacademy-research/minibar/master/minibar.py
chmod 775 minibar.py
```

5. Install latest version of pycoQC (https://a-slide.github.io/pycoQC/)
```
conda install -c aleg -c anaconda -c bioconda -c conda-forge pycoqc=2.5.0.17
```

6. Install minimap2 (https://github.com/lh3/minimap2)
```
conda install -c bioconda minimap2
```

7. Install samtools (https://github.com/samtools/samtools)
```
conda install -c bioconda samtools
```

8. Install longshot (https://github.com/pjedge/longshot)
```
conda install -c bioconda longshot
```


## Perform analysis of your data





***


## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
