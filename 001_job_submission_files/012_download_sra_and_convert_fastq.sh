# download .sra files

file_containing_sra_samples=sra_samples.txt

prefetch --option-file ${file_containing_sra_samples} -p


# convert .sra to fastq

# for i in `cat sra_samples.txt` ; do fasterq-dump $i/$i.sra -e 24 -p --outdir $i ; done

