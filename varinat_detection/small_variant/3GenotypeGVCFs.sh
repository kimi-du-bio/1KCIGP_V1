#!/bin/bash
#SBATCH -J GenotypeGVCFs
#SBATCH -N 1
#SBATCH -n 56
#SBATCH --mem=500gb

time /apps/bioinformatics/gatk-4.0.12.0/gatk \
GenotypeGVCFs \
-R reference.fa \
-V gendb:///GenomicsDBImport/ \
-O raw.vcf \
-D known-sites.vcf \
-G StandardAnnotation --use-new-qual-calculator
