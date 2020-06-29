The following lines describes the process to run IBDLD program. We assume that the user have already downloaded IBDLD program to a physical position in the laptop.

#STEPS:
1) Convert from hapmap to Plink format using TASSEL v.5.2.52 (Bradbury et al. 2007). Note: The conversion does not have to be using TASSEL v, it can be done using any other program.

$ /mnt/c/Program\ Files/TASSEL5/run_pipeline.pl -Xmx6g -fork1 -h Imputed_Genotypic_data.hmp.txt.gz -export -exportType Plink
- /mnt/c/Program\ Files/TASSEL5/ --> Local path to TASSEL

2) Running IBDLD program

$ /mnt/c/Users/deer1/Box\ Sync/02.IBD/14.IBDLD/IBDLDv3.38.1/ibdld -o Output
        -plink Imputed_Genotypic_data.plk.ped
        -m Imputed_Genotypic_data.plk.map
        -method GIBDLD
        -ploci 10 -dist 2
        -ibd 90 --ibdtxt
        -hbd --hbdtxt
        -segment
        --min 0.69
        --SNP 50
        --length 500

This program will have as output the file "Output.kinship" which correspond to the IBDLD kinship matrix.

# References
- Bradbury PJ, Zhang Z, Kroon DE, Casstevens TM, Ramdoss Y, Buckler ES (2007) TASSEL: software for association mapping of complex traits in diverse samples. Bioinformatics 23:2633-2635
