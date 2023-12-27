The 1KCIGP reference panel was constructed mainly using vcftools, whatshap and shapeit.

First, we filtered the SNPs which MAC<2.
```
sh 1pre.sh
```

Then, the local phase was based on whatshap. 
```
sh 2whatshap.sh
```

Finally, the population-based phasing was conducted by shapeit.
```
sh 3shapeit.sh
```
