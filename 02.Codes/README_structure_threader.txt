Created on May 15th, 2020

Below are the instructions of how to run structure_threader (Pina‐Martins et al. 2017) to have Structure 2.3.4 program (Pritchard et al. 2003) output.
The intructions part from the assumtipn that Structure 2.3.4 program have been already installed and that [structure_threader](https://github.com/StuntsPT/Structure_threader). 
The following were used following structure_threader [manual](https://structure-threader.readthedocs.io/en/latest/).

# STEPS
1. **Install**:
$ pip3 install structure_threader

2. **Input data**:
- Genotypic data: The format used correspond to two lines per each DH Line and the columns for each SNP marker
		  The alleles are coded as A (1), C(2), G(3) and T(4)	

3. Create the extraparams and mainparams file:
		 - extraparams: In our case this file was empty
		 - maiparams: All lines start with one #:

#define OUTFILE C:\Users\fsilvaag\Desktop\GWAS_REVIEW\STR_Threader\Proj1\Proj2\Results\Proj2_run_1
#define INFILE C:\Users\fsilvaag\Desktop\GWAS_REVIEW\STR_Threader\Proj1\project_data
#define NUMINDS 487
#define NUMLOCI 15891
#define LABEL 1 
#define POPDATA 0 
#define POPFLAG 0 
#define LOCDATA 0 
#define PHENOTYPE 0 
#define MARKERNAMES 1 
#define MAPDISTANCES 0 
#define ONEROWPERIND 0 
#define PHASEINFO 0 
#define PHASED 0 
#define RECESSIVEALLELES 0 
#define EXTRACOLS 0
#define MISSING 0
#define PLOIDY 2
#define MAXPOPS 1
#define BURNIN 10000
#define NUMREPS 20000

#define RANDOMIZE 0
#define SEED 1


#define NOADMIX 0
#define LINKAGE 0
#define USEPOPINFO 0

#define LOCPRIOR 0
#define INFERALPHA 1
#define ALPHA 1.0
#define POPALPHAS 0 
#define UNIFPRIORALPHA 1 
#define ALPHAMAX 10.0
#define ALPHAPROPSD 0.025


#define FREQSCORR 1 
#define ONEFST 0
#define FPRIORMEAN 0.01
#define FPRIORSD 0.05


#define INFERLAMBDA 0 
#define LAMBDA 1.0
#define COMPUTEPROB 1 
#define PFROMPOPFLAGONLY 0 
#define ANCESTDIST 1 
#define NUMBOXES 1000
#define ANCESTPINT 0.9
#define STARTATPOPINFO 1 
#define METROFREQ 10


#define UPDATEFREQ 1 
#define PRINTQHAT 1


4. Run structure_threader:
$ time ~/.local/bin/structure_threader run -K 11 -R 20 -i ../Structure_No-Duplicates.txt -o Resuls_10_20k --log T --params mainparams -t 30 -st ~/.local/bin/structure &

- time: To print the time the code takes to finish
- ~/.local/bin/structure_threader --> calling the program
- K 11 --> When specified like this it will run from 1 to 11
-R 20 --> Specify 20 replications per each K
-i --> Correspond to the genotypic data in Structure format (see structure manual for more information)
-o --> Output path 
--log --> Print the log files
--params --> specify the name of the file mainparams
-t --> number of threads




