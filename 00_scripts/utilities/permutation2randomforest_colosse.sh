#!/bin/bash
#PBS -A ihv-653-ab
#PBS -N permut2rf.__IDX__
#PBS -o permut2rf.__IDX__.out
#PBS -e permut2rf.__IDX__.err
#PBS -l walltime=24:00:00
#PBS -M YOUREMAIL
####PBS -m ea
#PBS -l nodes=1:ppn=8
#PBS -r n

# Move to job submission directory
cd $PBS_O_WORKDIR

NUMBER=__IDX__


##################################################################################################
################  Module 1: Random condition factor  ############################################
##################################################################################################

#prepare matrix

shuf 01_info_file/list_capilano.txt -o 01_info_file/CAP."$NUMBER"

shuf 01_info_file/list_quinsam.txt -o 01_info_file/QUI."$NUMBER"

cat 01_info_file/CAP."$NUMBER" 01_info_file/QUI."$NUMBER" >01_info_file/list_condition."$NUMBER"
paste 01_info_file/list_individuals.txt 01_info_file/list_condition."$NUMBER" >01_info_file/strata.TEMP."$NUMBER"


# Order strata file

for i in $(cat 01_info_file/order.matrix); do grep $i 01_info_file/strata.TEMP."$NUMBER" >>strata."$NUMBER".txt; done

# Clean up
rm 01_info_file/QUI."$NUMBER"
rm 01_info_file/CAP."$NUMBER"
rm 01_info_file/strata.TEMP."$NUMBER"


##################################################################################################
################  Module 4: Random Forest ########################################################
##################################################################################################

#launch RF
toEval="cat 00_scripts/utilities/script_rf_template.R | sed 's/__NB__/$NUMBER/g'"
   eval $toEval >RANDFOR_"$NUMBER".R

Rscript RANDFOR_"$NUMBER".R

#clean up
mv RANDFOR_"$NUMBER".R 99_log
mv PERM2RF_"$NUMBER".sh 99_log
