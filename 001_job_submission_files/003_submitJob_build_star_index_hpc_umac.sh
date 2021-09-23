#!/bin/bash
#SBATCH --job-name			job
#SBATCH --partition			FHS_NORMAL
#SBATCH --nodes				1
#SBATCH --tasks-per-node		36
#SBATCH --mem				48G
#SBATCH --time				8:00:00
#SBATCH --output			job.%j.out
#SBATCH --error				job.%j.err
#SBATCH --mail-type			FAIL
#SBATCH --mail-user			yb57653@um.edu.mo

genome_fasta_file="/home/yb57653/pearl/Projects/Nandan/candida_rnaseq/1_genome/c_glabrata/reference/C_glabrata_CBS138_version_s03-m01-r24_chromosomes.fasta" 
gtf_file="/home/yb57653/pearl/Projects/Nandan/candida_rnaseq/1_genome/c_glabrata/reference/C_glabrata_CBS138_version_s03-m01-r24_features.gtf"

# star index

STAR --runThreadN 36 \
--runMode genomeGenerate \
--genomeDir $PWD \
--genomeFastaFiles ${genome_fasta_file}  \
--sjdbGTFfile ${gtf_file} \
--sjdbOverhang 99