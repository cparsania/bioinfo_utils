RAW_DATA_DIR=/home/chiragp/data/6_dannel/1_pdac_patient_data/1_fastq/1_BAS10581-4522523
PATH_TO_BWA_INDEX=/spectrum/GSCT/REF/human/Human-GRCh38-release101/BWA_index/Homo_sapiens.GRCh38.dna.primary_assembly.fa
N_THREAD=6

for i in `cat sample_names.txt`

do


R1=$RAW_DATA_DIR/$i/${i}_L001_R1_001.fastq.gz
R2=$RAW_DATA_DIR/$i/${i}_L001_R2_001.fastq.gz
OUTPUT_PREFIX=$PWD/$i/${i}_bwa
submit_job_file=$PWD/$i/${i}_submit_job_new.sh

mkdir $i 
touch $submit_job_file 
	
echo  "\n\n\n">> $submit_job_file 
echo "###############" >> $submit_job_file 
echo "# BWA-MEM" >> $submit_job_file 
echo "###############" >> $submit_job_file 
echo  "\n\n\n">> $submit_job_file 

echo bwa mem ${PATH_TO_BWA_INDEX} ${R1} ${R2} -t ${N_THREAD} \| samtools sort -@${N_THREAD} -o ${OUTPUT_PREFIX}.bam - >> $submit_job_file

echo "\n\n\n" >> $submit_job_file
echo "###############  DONE ###############" >> $submit_job_file
echo "\n\n\n" >> $submit_job_file

done 
