#!/bin/bash
#SBATCH -J pre
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem=100gb


vcftools --vcf raw.snp.1filtered.vcf --mac 2 \
--recode --recode-INFO-all \
--out 1KCIGP

##depart chromsome
for i in {1..18}
do
	vcftools --vcf 1KCIGP.recode.vcf \
		-chr chr$i --recode --recode-INFO-all \
	--out 1KCIGP.chr$i
done

vcftools --vcf 1KCIGP.recode.vcf \
--recode --recode-INFO-all \
--bed chrX_PAR.bed \
--out KCIGP.chrX_PAR

vcftools --vcf 1KCIGP.recode.vcf \
--recode --recode-INFO-all \
--bed chrX_NPAR.bed \
--out KCIGP.chrX_NPAR

##extract each sample
samples=
for j in samples
do
	for s in {1..18} X_PAR X_NPAR
	do
		vcftools --vcf 1KCIGP.chr$s.recode.vcf \
		--indv $j \
		--recode --recode-INFO-all \
		--stdout | bgzip -c > 1KCIGP.chr$s.$j.vcf.gz

		tabix -p vcf 1KCIGP.chr$s.$j.vcf.gz
	done
done
