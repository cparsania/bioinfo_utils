
RAW_DATA_DIR=/home/chiragp/data/1_mehdi_rnaseq/3_mehdi_chip_seq/1_fastq
PATH_TO_BT2_INDEX=/spectrum/GSCT/REF/human/Human-GRCh38-release101/bowtie2/HS_GRCh38_release_101
N_THREAD=12
file_chrSize=/spectrum/GSCT/REF/human/Human-GRCh38-release101/STAR/chrNameLength.txt

for i in `cat sample_names.txt`

do

R1=$RAW_DATA_DIR/$i/${i}_1.fq.gz
R2=$RAW_DATA_DIR/$i/${i}_2.fq.gz
OUTPUT_PREFIX=$PWD/$i/${i}_bt2
submit_job_file=$PWD/$i/${i}_submit_job_new.sh
OUT_BDG=${OUTPUT_PREFIX}_normalised.bdg
OUT_BW=${OUTPUT_PREFIX}_normalised.bw

	mkdir $i 
	touch $submit_job_file 

echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file 
echo "# Bowtie2" >> $submit_job_file 
echo "###############" >> $submit_job_file 
echo  "\n\n\n">> $submit_job_file 

echo bowtie2 \
--threads ${N_THREAD} \
-q \
--local \
-x ${PATH_TO_BT2_INDEX} \
-1 ${R1} -2 ${R2} \| samtools view -bS - \| samtools sort -O bam -o ${OUTPUT_PREFIX}_sorted.bam >> $submit_job_file

echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file 
echo "#samtools index" >> $submit_job_file 
echo "###############" >> $submit_job_file 
echo  "\n\n\n">> $submit_job_file 

echo samtools index ${OUTPUT_PREFIX}_sorted.bam >> $submit_job_file 


echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file
echo "# Filtering uniquely mapping reads" >> $submit_job_file
echo "###############" >> $submit_job_file
echo "\n\n\n">> $submit_job_file 

echo sambamba view -h -t ${N_THREAD} -f bam \
-F \"[XS] == null and not unmapped  and not duplicate\" \
${OUTPUT_PREFIX}_sorted.bam \> ${OUTPUT_PREFIX}_unique_mapped.bam >> $submit_job_file


echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file
echo "# bam to normalised bedgraph" >> $submit_job_file
echo "###############" >> $submit_job_file
echo "\n\n\n">> $submit_job_file 


echo samtools flagstat ${OUTPUT_PREFIX}_unique_mapped.bam \> alignment.stats  >> $submit_job_file
echo "mappedReads=\`grep -P ' 0 mapped \(' alignment.stats | grep -P -o '^\d+'\`" >> $submit_job_file

echo "scale=\`perl -e \"printf('%.3f', 1000000/\${mappedReads})\"\`" >> $submit_job_file

echo "bedtools genomecov -scale \${scale} -bga -split -ibam ${OUTPUT_PREFIX}_unique_mapped.bam > ${OUT_BDG}" >> $submit_job_file

echo "bedtools sort -i $OUT_BDG > ${OUT_BDG}_sort" >> $submit_job_file

echo "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file
echo "# bedgraph to bw" >> $submit_job_file
echo "###############" >> $submit_job_file
echo  "\n\n\n">> $submit_job_file 

echo bedGraphToBigWig ${OUT_BDG}_sort \
${file_chrSize} \
${OUT_BW} >> $submit_job_file 	


echo "\n\n\n" >> $submit_job_file
echo "###############  DONE ###############" >> $submit_job_file
echo "\n\n\n" >> $submit_job_file

done
