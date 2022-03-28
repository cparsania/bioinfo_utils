
# BAM_DIR : path to a directory which contains bam file in a sample wise directory. Each sample directory must contain a single bam  file. 
# BAM_EXTENSION : an extension recognising a single bam file in each sample directory 
# PATH_TO_REF : path to ref directory 


BAM_DIR="/home/chiragp/data/3_IR_miRNA_interplay/2_public_data/4_liver_carcer_data/1_mouse/2_rnaseq/1_GSE97060/2_alignment"
BAM_EXTENSION="*.sortedByCoord.out.bam" 
PATH_TO_REF="/spectrum/GSCT/REF/mouse/Mouse-GRCm38-release86/"

for i in `cat sample_names.txt`

do 

outdir_name=$i
mkdir $outdir_name 
submit_job_file=$PWD/$outdir_name/${i}_submit_job_new.sh
touch $submit_job_file 

BAM_FILE=$BAM_DIR/$i/${BAM_EXTENSION}

echo  "\n\n\n">> $submit_job_file 

echo docker run -w $PWD \
-v $PATH_TO_REF:$PATH_TO_REF \
-v $BAM_DIR:$BAM_DIR \
-v $PWD/$outdir_name:$PWD/$outdir_name cloxd/irfinder:2.0 \
-m BAM \
-r $PATH_TO_REF \
-d $PWD/$outdir_name \
$BAM_FILE >> $submit_job_file

done 
