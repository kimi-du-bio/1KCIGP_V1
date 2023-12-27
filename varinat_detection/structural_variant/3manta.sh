#!/bin/bash
#SBATCH -J 1
#SBATCH -N 1
#SBATCH -n 18
#SBATCH --mem=200gb

name=$(ls *.recal.bam | xargs -I {} printf "--bam "{}" ")
configManta.py $name --referenceFasta reference.fa \
--runDir ./

runWorkflow.py -j 18
