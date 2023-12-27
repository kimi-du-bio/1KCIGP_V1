#!/bin/bash
#SBATCH -J pre
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=300gb

plink --noweb --file PCA \
--recode --allele1234 --out admix
fcgene --map admix.map \
--ped admix.ped --oformat eigensoft \
--group-label pop.txt --out example

