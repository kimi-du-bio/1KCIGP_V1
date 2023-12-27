#!/usr/bin/env bash

## quality control
bcftools annotate -x FORMAT "input_filename" -Ob -o "input.gt.bcf"
tabix -f "input.gt.bcf"

bcftools view "input.gt.bcf" --include 'REF~"[ACGT]" & ALT~"[ACGT]"' \
                             --exclude-uncalled \
                             --min-alleles 2 \
                             --max-alleles 2 \
                             --types snps \
                             -Ob -o "input.qc.bcf"
tabix -f "input.qc.bcf"

bcftools norm --rm-dup both "input.qc.bcf" -Ob -o "input.uniq.bcf"
tabix -f "input.uniq.bcf"

## phase

shapeit --thread 4 \
        --input "input.uniq.bcf" \
        --reference "panel_file" \
        --region chr \
        --output "output.phase.bcf" \
        --log "output.phase.log"
tabix -f "output.phase.bcf"

## impute

minimac4 "panel_file" "output.phase.bcf" --all-typed-sites \
                                         --chunk 500000 \
                                         --format GT \
                                         --region chr \
                                         --thread 4 \
                                         --output "output.impute.bcf" \
                                         --output-format bcf \
    2>&1 | tee "output.impute.log"
