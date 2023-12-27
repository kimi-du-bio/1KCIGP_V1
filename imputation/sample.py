#!/usr/bin/env python3

import numpy as np
import sys
import os

input_file = sys.argv[1]
sample_rate = int(sys.argv[2])

f_fill = open(f"snp_fill.dat", 'w+')
f_valid = open(f"snp_valid.dat", 'w+')

sample = list()
with open(input_file, 'r') as f:
    for line in f:
        chromosome, position = line.split()
        if len(sample) == 0:
            sample = list(np.random.choice(10, 10, replace=False))
        sample_snp = sample.pop(0)
        if sample_snp < sample_rate:
            pass
            f_valid.write(f"{chromosome} {position}\n")
        else:
            f_fill.write(f"{chromosome} {position}\n")
            f_debug.write(f"{chromosome} {position} 0\n")

f_fill.close()
f_valid.close()

print('Done!')
