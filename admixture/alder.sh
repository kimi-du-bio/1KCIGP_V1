#!/bin/bash
#SBATCH -J alder
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem=500gb
#SBATCH -p Fnode2

alder -p alder.par > alder.log
