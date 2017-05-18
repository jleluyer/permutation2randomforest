#!/bin/bash

ITERATION=$1


#launch loop
for i in $(eval echo "{1..$ITERATION}")
do
  toEval="cat 00_scripts/utilities/permutation2randomforest_colosse.sh | sed 's/__IDX__/$i/g'"
    eval $toEval >PERM2RF_"$i".sh
done

#launch scripts

for i in $(ls PERM2RF*sh)
do
chmod +x $i
msub "$i"
done
