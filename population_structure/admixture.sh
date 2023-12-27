#!/bin/bash
#SBATCH -J pca
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 30
#SBATCH --mem=100gb

for K in {2..6}
do
	mkdir $K
	admixture -j30 --cv=5 \
	PCA.bed $K | tee log${K}.out
done
