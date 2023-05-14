# Adjust this single line of code to specify the absolute path to the reference genome for mapping and variant calling
REFERENCE="/Users/maikschauerte/Data-Analysis/NP_final/ONTrun_079/CRISPRT4/input/reference/NC_000866-4.fasta"
GFF3="/Users/maikschauerte/Data-Analysis/NP_final/ONTrun_079/CRISPRT4/input/reference/NC_000866-4.gff3"

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

# Specify the target region for variant calling. This is a string combining the reference genome id and the region indicated by numbers, for instance the following region for alt gene
TargetRegion="NC_000866.4:123454-125502"

cd output/alignment
for FILE in *sorted.bam
do
VCFFILE="${FILE/%_sorted.bam/_variants.vcf}"
longshot --bam $FILE --ref $REFERENCE --out $VCFFILE --max_cov 120000 -F -r $TargetRegion
done

mv *.vcf ..
cd ..
mv *.vcf vcfFiles

cd alignment 

featureCounts -a $GFF3 -t gene -g ID -L -O --primary -o counts_table.tsv *.sam
mv counts_table.tsv ..
mv counts_table.tsv.summary ..
cd ..
mv counts_table.tsv countData
mv counts_table.tsv.summary countData

  