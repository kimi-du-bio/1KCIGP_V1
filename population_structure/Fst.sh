#!/bin/bash
#SBATCH -J filter_select
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

vcftools --vcf raw.snp.1filtered.vcf \
--weir-fst-pop group1.txt \
--weir-fst-pop group2.txt \
--fst-window-size 100000 --fst-window-step 10000 \
--out group1_group2
