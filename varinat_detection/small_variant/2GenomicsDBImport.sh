#!/bin/bash
#SBATCH -J GenomicsDBImport
#SBATCH -N 1
#SBATCH -n 56
#SBATCH --mem=500gb

ulimit -n 100000
time gatk GenomicsDBImport \
--genomicsdb-workspace-path GenomicsDBImport/ \
--sample-name-map input.gvcfs.list \
--reader-threads 56
