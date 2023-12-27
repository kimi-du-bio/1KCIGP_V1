Call SVs using Delly2, Lumpy, Manta and Wham.
```
sh 1delly2.sh
sh 2lumpy.sh
sh 3manta.sh
sh 4wham.sh
```

The SVs detected from four softwares were first merged on individual level. Then, joint the results of each individual into the population level. The merge process was conducted by SURVIVOR, it need the config file that listed the file path which want to merge. An example like follows:
```
example.delly.vcf
example.lumpy.vcf
example.manta.vcf
example.wham.vcf
```
Then, run the following command:
```
sh 5merge.sh
```
