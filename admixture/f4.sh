#!/bin/bash
#SBATCH -J f4
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=100gb

time AdmixTools-7.0.1/bin/qpDstat \
-p f4.par \
> logfile.f4
echo "done!"
