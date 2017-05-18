#!/bin/bash
#PBS -A ihv-653-ab
#PBS -N admixture
#PBS -o admixture.out
#PBS -e admixture.err
#PBS -l walltime=02:00:00
#PBS -M YOUREMAIL
####PBS -m ea
#PBS -l nodes=1:ppn=8
#PBS -r n

# Move to job submission directory
cd $PBS_O_WORKDIR

#Admixture
cd 02_vcf


# Change loci name (only for admixture membership calculations)
sed -e 's/Okis//g' -e 's/scaffold/9/g' dataset.initial.vcf >dataset.vcf

# Run admixture
inputvcf="$(echo dataset.vcf|sed 's/.vcf//g')"

plink --vcf "$inputvcf".vcf --recode --out "$inputvcf".impute --double-id --allow-extra-chr --chr-set 55
plink --file "$inputvcf".impute --make-bed --out "$inputvcf".impute --allow-extra-chr --chr-set 55
admixture "$inputvcf".impute.bed 2
cd ..


# Prepare admixture data
cut -f 1 02_vcf/dataset.impute.2.Q >02_vcf/admixture.txt
paste 01_info_file/list_individuals.txt 02_vcf/admixture.txt >03_matrices/matrix.admixture.txt

# Extract genet info
vcf-to-tab < 02_vcf/dataset.initial.vcf > 02_vcf/out.tab

#prepare genetic matrix
grep -v '#' 02_vcf/out.tab|cut -f -2,4-|awk '{print $1"_"$2}' >03_matrices/loci.matrix.txt


#Deprecated
#grep -v '#' 02_vcf/out.tab|cut -f -2,4-|cut -f 3- >03_matrices/TEMP.matrix.txt
#grep 'CHR' 02_vcf/dataset.vcf|cut -f 10- >03_matrices/header.txt
#cat 03_matrices/header.txt 03_matrices/TEMP.matrix.txt >03_matrices/matrix.genetic.txt


