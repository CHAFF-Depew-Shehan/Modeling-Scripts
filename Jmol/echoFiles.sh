#!/bin/bash

nstart=46000
nevery=20
nstop=53600
for i in $(seq -f "%06g" $nstart $nevery $nstop)
do
    echo -n \"step_${i}.pdb\"\ 
done
