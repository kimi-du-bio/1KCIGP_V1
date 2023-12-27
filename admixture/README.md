Before conduct the f3 and f4 analyses, the vcf file need to transfer to eigensoft format using the following script:
```
sh 0pre.sh
```

The f3 analysis can be run as follows, and the config file was f3.par file. 
```
sh f3.sh
```

The f4 analysis can be run as follows, and the config file was f4.par file. 
```
sh f4.sh
```

The pipeline of Dfoil analysis was detailed described in the dfoil.sh script.
```
sh dfoil.sh
```

The treemix analysis can be run as follows:
```
sh treemix.sh
```

The admixture event time was estimated by alder, and the config file was alder.par file. 
```
sh alder.sh
```
