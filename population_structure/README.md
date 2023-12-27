Principal component analysis (PCA) was performed using GCTA.
`
sh PCA.sh
`

The neighbor-joining tree was constructed based on a pairwise genetic distance matrix calculated by emmax. 
`
sh phylogenetic_tree.sh
`

Genetic clustering analysis was performed by ADMIXTURE.
`
sh admixture.sh
`

The Fst was calculated by vcftools.
`
sh Fst.sh
`

The effective population size was evaluated by the SMC++.
`
smc++.sh
`