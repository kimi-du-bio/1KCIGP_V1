#!/bin/bash
#SBATCH -J pre
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem=100gb

samples=
for j in samples
do
	for s in {1..18} X_PAR X_NPAR
	do
		whatshap phase \
		-o 1KCIGP.chr$s.$j.whatshap.vcf \
		--reference=reference.fa \
		1KCIGP.chr$s.$j.vcf.gz \
		$j.recal.bam
	done
done

gvcfs=""
while read line
do
	gvcfs=${gvcfs}"${line}.vcf.gz "
done  < sample_list.txt  ##This file contained the vcf file path for each sample after processed by whatshap, do this process and the following script one chromsome by one

vcftools/src/perl/vcf-merge \
$gvcfs \
> chromosome.whatshap.vcf
