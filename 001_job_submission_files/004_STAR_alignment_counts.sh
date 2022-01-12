
# reads statistics Number of input reads

for i in `ls -a */*final.out` ; do echo -n $i ; cat $i | grep "Number of input reads" ; done 

# reads statistics Uniquely mapped reads number

for i in `ls -a */*final.out` ; do echo -n $i ; cat $i | grep "Uniquely mapped reads number" ; done 

# reads statistics Uniquely mapped reads % 

for i in `ls -a */*final.out` ; do echo -n $i ; cat $i | grep "Uniquely mapped reads % " ; done
