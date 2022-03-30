

# trim and remove duplicates from fastq file. Output will be saved in the same directory of this script. 

#FASTQ_DIR = denotes path to a directory containing fastq files in a sample wise arrangement. 

FASTQ_DIR="/home/chiragp/data/3_IR_miRNA_interplay/2_public_data/4_liver_carcer_data/1_mouse/1_clipseq/1_GSE97058/1_fastq"
FASTQ_EXTENSION=".fastq" 
ADAPTOR_SEQ="GTGTCAGTCACTTCCAGCGG"
CORES=36

for i in `cat sample_names.txt`

do

SUBMIT_JOB_FILE=${FASTQ_DIR}/${i}/${i}_trim_and_remove_dups.sh 
touch ${SUBMIT_JOB_FILE}

FASTQ_FILE=$FASTQ_DIR/$i/${i}${FASTQ_EXTENSION}
FASTQ_FILE_NAME=`basename ${FASTQ_FILE} ${FASTQ_EXTENSION}`
OUTPUT_TRIMMED_FASTQ=${FASTQ_FILE_NAME}_trimmed${FASTQ_EXTENSION}
OUTPUT_NODUPS_FASTQ=${FASTQ_FILE_NAME}_trimmed_nodups${FASTQ_EXTENSION}


echo " # remove adaptor and preceding  sequences from 5' end. 
# -u 5 trim first five bp from left side (5' end) before adaptor trimming 
# -e 2 allows 2 mismatch.
# -O minmum overlap
# -m minimum length. Discard reads shorter than LEN
# -g Sequence of an adapter ligated to the 5' end
# -a Sequence of an adapter ligated to the 3' end
# --cores no of cores, 0 auto detact " >> ${SUBMIT_JOB_FILE}


echo  "\n\n\n" >> $SUBMIT_JOB_FILE 


echo "###############" >> $SUBMIT_JOB_FILE 
echo "# CUTADAPT" >> $SUBMIT_JOB_FILE
echo "###############" >> $SUBMIT_JOB_FILE 


echo  "\n\n\n" >> $SUBMIT_JOB_FILE 

echo "# strip 21 nt from 5' end and  remove adaptor from 3' end. -e 2 allows 2 mismatch" >> $SUBMIT_JOB_FILE

echo cutadapt -u 21 -m 20  -O 10  -e 2 -a $ADAPTOR_SEQ  -o ${OUTPUT_TRIMMED_FASTQ} ${FASTQ_FILE} --cores ${CORES} >> $SUBMIT_JOB_FILE


echo "###############" >> $SUBMIT_JOB_FILE 
echo "# clumpify.sh" >> $SUBMIT_JOB_FILE 
echo "###############" >> $SUBMIT_JOB_FILE 



echo "# remove duplicate sequences" >> $SUBMIT_JOB_FILE

echo clumpify.sh in=${OUTPUT_TRIMMED_FASTQ} dedupe=t out=${OUTPUT_NODUPS_FASTQ} groups=16 >> $SUBMIT_JOB_FILE



done 

