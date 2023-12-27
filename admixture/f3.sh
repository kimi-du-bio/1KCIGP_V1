#!/bin/bash
#SBATCH -J f3
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

time AdmixTools-7.0.1/bin/qp3Pop \
-p f3.par \
> logfile.f3
echo "done!"
