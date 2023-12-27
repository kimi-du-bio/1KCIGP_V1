#!/bin/bash

module load vcftools

vcftools --gzvcf snp.vcf.gz --keep ./CES.txt --window-pi 100000 --window-pi-step 10000 --out CES
vcftools --gzvcf snp.vcf.gz --keep ./ET.txt --window-pi 100000 --window-pi-step 10000 --out ET
vcftools --gzvcf snp.vcf.gz --keep ./N.txt --window-pi 100000 --window-pi-step 10000 --out N
vcftools --gzvcf snp.vcf.gz --keep ./S.txt --window-pi 100000 --window-pi-step 10000 --out S
vcftools --gzvcf snp.vcf.gz --keep ./WS.txt --window-pi 100000 --window-pi-step 10000 --out WS
