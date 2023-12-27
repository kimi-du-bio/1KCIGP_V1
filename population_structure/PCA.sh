#!/bin/bash
#SBATCH -J pca
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

vcftools --vcf raw.snp.1filtered.vcf \
--plink \
--out PCA

plink --noweb \
--file PCA \
--make-bed --out PCA

gcta64  \
--bfile PCA \
--make-grm --autosome \
--out PCA

gcta64 \
--grm PCA \
--pca 3 --out pcamerge
