#! /bin/bash

### calculate fst for pairwise comparison (For example: CES VS ET)

### calculate fst: CES VS ET
vcftools \
--gzvcf ./snp.vcf.gz \
--weir-fst-pop ./file/CES.txt \
--weir-fst-pop ./file/ET.txt \
--fst-window-size 100000 \
--fst-window-step 10000 \
--out ./CES_vs_ET_fst

### calculate fst: CES VS outgroup
vcftools \
--gzvcf ./snp.vcf.gz \
--weir-fst-pop ./file/CES.txt \
--weir-fst-pop ./file/EUD.txt \
--fst-window-size 100000 \
--fst-window-step 10000 \
--out ./CES_vs_EUD_fst

### calculate fst: ET VS outgroup
vcftools \
--gzvcf ./snp.vcf.gz \
--weir-fst-pop ./file/ET.txt \
--weir-fst-pop ./file/EUD.txt \
--fst-window-size 100000 \
--fst-window-step 10000 \
--out ./ET_vs_EUD_fst
