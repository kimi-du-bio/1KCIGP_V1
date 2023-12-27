#!/bin/bash
#SBATCH -J 1
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=200gb

samples=

##call for each individual
for i in samples
do
	SURVIVOR merge \
	$i.file \
	1000 2 1 1 0 50 $i.merge.vcf
done

SURVIVOR merge \
all.merge.file \
1000 2 1 1 0 50 merge.vcf
