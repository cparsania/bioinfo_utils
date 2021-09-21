#!/bin/bash 
#SBATCH --job-name                      featureCount
#SBATCH --partition                     FHS_NORMAL 
#SBATCH --nodes                         1 
#SBATCH --tasks-per-node                6
#SBATCH --mem                           24G 
#SBATCH --time                          8:00:00
#SBATCH --output                        job.%j.out 
#SBATCH --error                         job.%j.err 
#SBATCH --mail-type                     FAIL 
#SBATCH --mail-user                     yb57653@um.edu.mo

path_to_gtf_file=""
path_to_bam_dir=""

# NOTE : variable path_to_bam_dir denotes a path upto a directory in which .bam files are stored in samplewise directory.
bam_extension="sortedByCoord.out.bam" 
out_file=featureCount_output.txt
all_bams_full_path=`echo $path_to_bam_dir/*/*${bam_extension}`

# featureCount 
featureCounts \
-a ${path_to_gtf_file} \
-o ${out_file} \
${all_bams_full_path} \
-g gene_id \
-F GTF \
-t exon \
-T 24 \
-s 1 \
-p

# featureCount args

# -g Specify attribute type in GTF annotation. 'gene_id' by  default. Meta-features used for read counting will be extracted from annotation using the provided value.
# -p If specified, fragments (or templates) will be counted instead of reads. This option is only applicable for paired-end reads; single-end reads are always counted as reads.
# -s <int or string>  Perform strand-specific read counting. A single integer value (applied to all input files) or a string of comma separated values (applied to each corresponding input file) should be provided. Possible values include:
                      # 0 (unstranded), 1 (stranded) and 2 (reversely stranded).
                      # Default value is 0 (ie. unstranded read counting carried
                      # out for all input files).

