# Adjust these lines of code to specify the absolute path to the reference genome for mapping and variant calling
REFERENCE="/Users/example_user/CRISPRT4/input/reference/NC_000866-4.fasta"
GFF3="/Users/example_user/CRISPRT4/input/reference/NC_000866-4.gff3"


cd input/fastq
for FILE in *.fastq
do
SAMFILE="${FILE/%.fastq/.sam}"
BAMFILE="${FILE/%.fastq/.bam}"
BAMFILESORTED="${FILE/%.fastq/_sorted.bam}"
minimap2 -ax map-ont $REFERENCE $FILE > $SAMFILE
samtools view -S -b $SAMFILE > $BAMFILE
samtools sort $BAMFILE -o $BAMFILESORTED
samtools index $BAMFILESORTED
done
mv *.bam *.sam *.bai ..
cd .. 
mv *.bam *.sam *.bai ..
cd .. 
mv *.bam *.sam *.bai output/alignment
