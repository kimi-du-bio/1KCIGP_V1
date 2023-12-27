#!/bin/bash
#SBATCH -J filter_select
#SBATCH -N 1
#SBATCH -n 56
#SBATCH --mem=500gb

gatk SelectVariants \
-select-type SNP \
-V raw.vcf \
-O raw.snp.vcf

# Hard Filtration for SNP
gatk VariantFiltration \
-V raw.snp.vcf \
--filter-expression "DP<10 || QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
--cluster-size 3 --cluster-window-size 10 \
--filter-name "Filter" \
-O raw.snp.marker.vcf

# extract the "PASS" sites
grep -vE "SnpCluster|Filter" \
raw.snp.marker.vcf \
> raw.snp.1filtered.vcf

# using SelectVariants modeule to select Indel
gatk SelectVariants \
-select-type INDEL \
-V raw.vcf \
-O raw.indel.vcf

# Hard Filtration for Indel
gatk VariantFiltration \
-V raw.indel.vcf \
--filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
--filter-name "Filter" \
-O raw.indel.marker.vcf

# extract the "PASS" sites
grep -v "Filter" \
raw.indel.marker.vcf \
> raw.indel.1filtered.vcf
