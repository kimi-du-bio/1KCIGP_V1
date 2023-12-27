#!/bin/bash
#SBATCH -J 1
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=200gb

samples=

##call for each individual
for i in samples
do
	lumpyexpress \
	-B $i.recal.bam \
	-o $i.vcf
done

##genotype SVs for each individual
for i in samples
do
	svtyper \
	-i $i.vcf \
	-B $i.recal.bam \
	-o $i.geno.vcf \
	-T reference.fa
done
