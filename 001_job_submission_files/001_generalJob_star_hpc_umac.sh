# RAW_DATA_DIR : path to directory sample wise directories. Each sample directory contain fastq (r1 & r2) fastq files.
# GENOME_DIR : path to star genome 

RAW_DATA_DIR=/home/yb57653/pearl/Projects/Nandan/candida_rnaseq/2_fastq
GENOME_DIR=/home/yb57653/pearl/Projects/Nandan/candida_rnaseq/1_genome/c_glabrata/star_index/
N_THREAD=12
file_chrSize=/home/yb57653/pearl/Projects/Nandan/candida_rnaseq/1_genome/c_glabrata/star_index/chrNameLength.txt

for i in `cat sampleName.txt`

do

R1=$RAW_DATA_DIR/$i/${i}_r1.fastq.gz
R2=$RAW_DATA_DIR/$i/${i}_r2.fastq.gz
OUTPUT_PREFIX=$PWD/$i/${i}_star_align
submit_job_file=$PWD/$i/${i}_submit_job_new.sh
OUT_BDG=${OUTPUT_PREFIX}_normalised.bdg
OUT_BW=${OUTPUT_PREFIX}_normalised.bw


	mkdir $i 
	touch $submit_job_file 

echo "#!/bin/bash 
#SBATCH --job-name                     ${i}_star 
#SBATCH --partition                     FHS_NORMAL 
#SBATCH --nodes                         1 
#SBATCH --tasks-per-node                6
#SBATCH --mem                           24G 
#SBATCH --time                          8:00:00
#SBATCH --output                        job.%j.out 
#SBATCH --error                         job.%j.err 
#SBATCH --mail-type                     FAIL 
#SBATCH --mail-user                     yb57653@um.edu.mo

" >> $submit_job_file 

echo -e "\n\n\n">> $submit_job_file 

echo "# STAR" >> $submit_job_file 

echo -e "\n\n\n">> $submit_job_file 

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

echo -e "\n\n\n">> $submit_job_file 

echo "# bam to bedgraph" >> $submit_job_file 

echo -e "\n\n\n">> $submit_job_file 

echo "mappedReads=\`cat $PWD/$i/*.final.out | grep \"Uniquely mapped reads number\" | grep -o '[[:digit:]]*'\`" >> $submit_job_file
echo "scale=\`perl -e \"printf('%.3f', 1000000/\${mappedReads})\"\`" >> $submit_job_file

echo "bedtools genomecov -scale \${scale} -bga -split -ibam *sortedByCoord.out.bam > ${OUT_BDG}" >> $submit_job_file

echo "bedtools sort -i $OUT_BDG > ${OUT_BDG}_sort" >> $submit_job_file

echo -e "\n\n\n">> $submit_job_file 

echo "# bedgraph to bw" >> $submit_job_file 

echo -e "\n\n\n">> $submit_job_file 

echo bedGraphToBigWig ${OUT_BDG}_sort \
${file_chrSize} \
${OUT_BW} >> $submit_job_file 	

done