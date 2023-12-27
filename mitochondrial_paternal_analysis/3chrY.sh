#!/bin/bash
#SBATCH -J chrY
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

##filter SNP

gatk VariantFiltration \
-V chrY.vcf \
-O /chrY.VF.vcf --genotype-filter-expression "isHet == 1" --genotype-filter-name "isHetFilter"

/home/duh/software/gatk-4.2.6.1/gatk SelectVariants \
-V chrY.VF.vcf \
--set-filtered-gt-to-nocall \
-O chrY.VF.SV

vcftools --vcf chrY.VF.SV.recode.vcf \
--max-missing 0.95 --non-ref-ac-any 1 \
--recode --out chrY.VF.SV.missing
