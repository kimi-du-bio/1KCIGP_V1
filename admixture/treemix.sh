#!/bin/bash
#SBATCH -J treemix
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=300gb

plink \
--tfile PCA --freq \
--missing --within pop.csv

gzip -c plink.frq.strat > plink.frq.strat.gz

python2 treemix-1.13/plink2treemix.py \
plink.frq.strat.gz \
treemix.frq.gz

echo "done"

for m in {1..10}
do
   for i in {1..10}
    do
      treemix -bootstrap \
         -i treemix.frq.gz \
         -o treemix.${i}.${m} \
         -global \
         -m ${m} \
         -k 1000 \
         -root Outgroup
	done
done
