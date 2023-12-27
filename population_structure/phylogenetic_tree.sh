#!/bin/bash
#SBATCH -J pca
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

plink \
--noweb --bfile raw.snp.1filtered.vcf \
--recode12 --output-missing-genotype 0 --transpose \
--out tree

emmax-kin -s -v -h -d 10 \
tree
