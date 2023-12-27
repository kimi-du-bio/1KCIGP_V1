#!/bin/bash
#SBATCH -J mito
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=100gb

MitoToolPy_Linux/mitotoolpy-seq.py \
-s pig -r whole \
-i all.mito.fasta \
-o results.txt
