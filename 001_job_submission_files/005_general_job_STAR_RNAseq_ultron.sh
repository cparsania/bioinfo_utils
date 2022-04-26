# RAW_DATA_DIR : path to directory sample wise directories. Each sample directory contain fastq (r1 & r2) fastq files.
# GENOME_DIR : path to star genome 



RAW_DATA_DIR=/home/chiragp/data/1_mehdi_rnaseq/2_znf219_interferon_rnaseq/1_fastq/1_fq/
GENOME_DIR=/spectrum/GSCT/REF/human/Human-GRCh38-release101/STAR/
N_THREAD=12
file_chrSize=/spectrum/GSCT/REF/human/Human-GRCh38-release101/STAR/chrNameLength.txt

for i in `cat sample_names.txt`

do

R1=$RAW_DATA_DIR/$i/${i}_r1.fq.gz
R2=$RAW_DATA_DIR/$i/${i}_r2.fq.gz
OUTPUT_PREFIX=$PWD/$i/${i}_star_align
submit_job_file=$PWD/$i/${i}_submit_job_new.sh
OUT_BDG=${OUTPUT_PREFIX}_normalised.bdg
OUT_BW=${OUTPUT_PREFIX}_normalised.bw


	mkdir $i 
	touch $submit_job_file 

echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file 
echo "# STAR" >> $submit_job_file 
echo "###############" >> $submit_job_file 
echo  "\n\n\n">> $submit_job_file 

echo STAR \
--limitBAMsortRAM 100000000000 \
--genomeLoad LoadAndKeep \
--runThreadN $N_THREAD \
--genomeDir $GENOME_DIR \
--readFilesCommand zcat \
--readFilesIn $R1 $R2 \
--outFileNamePrefix  $OUTPUT_PREFIX \
--outSAMtype BAM SortedByCoordinate \
--outWigType  bedGraph \
--outWigNorm RPM >> $submit_job_file

echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file
echo "# bam to bedgraph" >> $submit_job_file
echo "###############" >> $submit_job_file
echo "\n\n\n">> $submit_job_file 

echo "mappedReads=\`cat $PWD/$i/*.final.out | grep \"Uniquely mapped reads number\" | grep -o '[[:digit:]]*'\`" >> $submit_job_file
echo "scale=\`perl -e \"printf('%.3f', 1000000/\${mappedReads})\"\`" >> $submit_job_file

echo "bedtools genomecov -scale \${scale} -bga -split -ibam *sortedByCoord.out.bam > ${OUT_BDG}" >> $submit_job_file

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
