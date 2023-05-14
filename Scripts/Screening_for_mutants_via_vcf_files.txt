cd output/vcfFiles
for FILE in *.vcf
do
echo $FILE
cat $FILE | grep -v "#"
echo "------------------------------------"
done


