#!/bin/bash
#SBATCH -J pca
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 X
do
	smc++ vcf2smc group.vcf.gz \
	chr$i.smc.gz \
	chr$i group:sample1,sample2,sample3
done

smc++ estimate -o analysis/ \
2.5e-8 chr*.smc.gz

smc++ plot plot.pdf \
analysis/model.final.json \
-g 5 -c
