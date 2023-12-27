# Imputation analysis

## Imputation

A basic imputation process can be performed using the script we provide.

```bash
chmod +x ./imputation.sh
./imputation.sh
```
## Imputation accuracy verification

Imputation accuracy verification requires extracting the reference dataset and the validation dataset.

```bash
# Extraction based on site proportions
python3 sample.py

# Extraction based on SNP density
python3 sample_number.py

# Extraction vcf file
vcftools --vcf input.vcf --positions snp_fill.dat --recode --out output
```

Impute using the imputation script.

```bash
./imputation.sh
```

Verify fill accuracy


```bash
python3 compare.py
```
