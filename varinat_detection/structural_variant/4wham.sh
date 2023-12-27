#!/bin/bash
#SBATCH -J 1
#SBATCH -N 1
#SBATCH -n 50
#SBATCH --mem=200gb

samples=

##call SVs for each individual
for i in samples
do
	whamg -f $i.recal.bam \
	-a reference.fas -x 50 \
	-c chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chrX,chrY \
	> $i.vcf
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
