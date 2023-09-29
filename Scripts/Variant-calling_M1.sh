# Adjust these lines of code to specify the absolute path to the reference genome for mapping and variant calling
REFERENCE="/Users/.../CRISPRT4/input/reference/NC_000866-4.fasta"
GFF3="/Users/.../CRISPRT4/input/reference/NC_000866-4.gff3"

# Specify the target region for variant calling. This is a string combining the reference genome id and the region indicated by numbers, for instance the following region for modA gene
TargetRegion="NC_000866.4:11908-12510"

cd output/alignment
for FILE in *sorted.bam
do
VCFFILE="${FILE/%_sorted.bam/_variants.vcf}"
longshot --bam $FILE --ref $REFERENCE --out $VCFFILE --max_cov 120000 -F -x -E 0.6 -r $TargetRegion
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
