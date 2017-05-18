#!/bin/bash

grep OOB slim2randomforest_mut*/04_results/*err.rate*|sed -e 's#/04_results/selected_marker25.err.rate.[0-9]*.txt:OOB#\t#g' -e 's#slim2randomforest_mut10##g' -e 's#_gen#\t#g' >result_OOB.txt

