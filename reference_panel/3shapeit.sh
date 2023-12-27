#!/bin/bash
#SBATCH -J pre
#SBATCH -p cluster
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --mem=100gb

samples=
for j in samples
do
	for s in {1..18}
	do
		shapeit4.2 \
		--input chr$s.whatshap.vcf \
		--use-PS 0.0001 --output chr$s.whatshap.shapeit.vcf \
		-T 20
	done
done

##NPAR region of X chromosome in pig was separated into two regions
shapeit4.2 \
--input chrX_NPAR.whatshap.vcf \
--use-PS 0.0001 --output chrX_NPAR1.whatshap.shapeit.vcf \
-T 20 --region chrX:1-1029481

/shapeit4.2 \
--input chrX_NPAR.whatshap.vcf \
--use-PS 0.0001 --output chrX_NPAR2.whatshap.shapeit.vcf \
-T 20 --region chrX:6405431-125939595

##PAR region of X chromosome
shapeit4.2 \
--input chrX_PAR.whatshap.vcf \
--use-PS 0.0001 --output chrX_PAR.whatshap.shapeit.vcf \
-T 20 --region chrX:1029482-6405430
