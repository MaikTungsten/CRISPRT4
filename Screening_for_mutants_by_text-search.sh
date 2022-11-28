cd input/fastq
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


