#!/bin/bash


cd ./GWAS1

gemma-0.98.5 -bfile ../GWAS1 \
-k ./output/Kjuzhen.sXX.txt \
-notsnp -miss 1 -r2 1.0 -lmm 1 -n 1 -c c.txt -o result
