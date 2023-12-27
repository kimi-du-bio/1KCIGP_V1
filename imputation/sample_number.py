#!/usr/bin/env python3

import numpy as np
import sys
import os

input_file = sys.argv[1]

sample_number = int(sys.argv[2]) * 1000

f_fill = open(f"snp_fill.dat", 'w+')

sample = list()
with open(input_file, 'r') as f:
    snp = f.readlines()

snp_number = len(snp)

rate = int(snp_number / sample_number)

for line in snp:
    chromosome, position = line.split()
    if len(sample) == 0:
        sample = list(np.random.choice(rate, rate, replace=False))
    sample_snp = sample.pop(0)
    if sample_snp == 1:
        f_fill.write(f"{chromosome} {position}\n")

f_fill.close()

print('Done!')
