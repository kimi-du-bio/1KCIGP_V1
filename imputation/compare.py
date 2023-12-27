#!/usr/bin/env python3

import re
import sys
import numpy as np

fill_file = sys.argv[1] or "impute.fill.recode.vcf"
valid_file = sys.argv[2] or "impute.valid.recode.vcf"

output_file = sys.argv[3] or "compare.txt"

with open(fill_file) as f:
    fill_dat = [x for x in f.readlines() if x[0] != '#']

with open(valid_file) as f:
    valid_dat = [x for x in f.readlines() if x[0] != '#']

if len(fill_dat) != len(valid_dat):
    print("Invalid snp number"+ fill_file)
    exit(1)

with open(fill_file) as f:
    for line in f.readlines():
        if line[:6] == '#CHROM':
            header = line.split()[9:]
            break

output = [0] * len(header)
snp_number = 0

# f_out = open(output_file, "w+")

# f_out.write("\t".join(["chr", "pos"] + header) + '\n')

for fill, valid in zip(fill_dat, valid_dat):
    fill = [x for x in fill.split()]
    valid = [x for x in valid.split()]

    snp = fill[:2]

    if fill[1] != valid[1]:
        print("Invalid snp location")
        exit(2)

    fill = "".join(fill[9:]).replace("|", "")
    valid = "".join(valid[9:]).replace("|", "")

    fill = int(fill, 2)
    valid = int(valid, 2)

    compare = bin(fill ^ valid).lstrip("0b").rjust(2 * len(header), '0')

    compare = re.findall(r'\w{2}', compare)

    compare = [sum(map(int, x)) for x in compare]

    compare = [str(x) for x in compare]

    # f_out.write("\t".join(snp + compare) + '\n')

    output = np.sum([output, compare], axis=0)

    snp_number += 2

output = [str(1 - x / snp_number) for x in output]

output = ["\t".join(x) + '\n' for x in list(zip(header, output))]

with open(output_file, "w+") as f:
    f.writelines(output)
