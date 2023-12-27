#!/bin/bash
#SBATCH -J 1
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=200gb

samples=

##call for each individual
for i in samples
do
	delly call \
	-g reference.fa -q 20 -s 5 \
	-o $i.bcf \
	$i.recal.bam
done

##merge SVs
name=$(ls *.bcf | xargs -I {} printf {}" ")
delly merge $name -o merge.bcf

##recall
for i in samples
do
	delly call \
	-g reference.fa \
	-v merge.bcf \
	-o $i.geno.bcf \
	$i.recal.bam
done

##remerge
name2=$(ls *.geno.bcf | xargs -I {} printf {}" ")
bcftools merge -m id -O b -o merge2.bcf $name2

##filter
delly \
filter -f germline \
-o germline.bcf \
merge2.bcf
