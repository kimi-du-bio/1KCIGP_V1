#!/bin/bash
#SBATCH -J dfoil
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --mem=50gb

##change the SNP format
python3 mvftools-main/mvftools.py \
ConvertVCF2MVF --vcf sample.vcf --out DATA.mvf

##run dfoil
cat P1.txt | while read P1
do
	cat P2.txt | while read P2
	do
		cat P3.txt | while read P3
		do
			python3 mvftools-main/mvftools.py \
			--mvf DATA.mvf \
			--out ${P1}-${P2}-${P3}.TV.vcf.mvf.txt \
			--windowsize 200000 --samples ${P1},${P2},${P3},P4,Outgroup
			dfoil-master/dfoil.py \
			--infile ${P1}-${P2}-${P3}.TV.vcf.mvf.txt --pvalue 0.01 \
			--out ${P1}-${P2}-${P3}.TV.vcf.mvf.txt.stats
		done
	done
done

