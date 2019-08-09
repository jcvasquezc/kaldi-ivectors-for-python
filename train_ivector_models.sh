#!/bin/bash
# Copyright 2016  Nicanor garcia
# Apache 2.0.
# Edited 2019
# Juan Camio Vasquez-Correa
# juan.vasquez@fau.de
#

M=$1
ivector_dim=$2
num_gselect=$3
featFile=$4
mDir=$5


. path.sh

#Compute feats
echo $featFile
if [ ! -f ${featFile} ]; then echo "There are no characteristics to process"; exit 1; fi

# Generate the UBMs
# k=$( echo "l($M)/l(2)" | bc -l )
# k=${k%.*}
# num_gselect=$((k+1))

SCRIPT_PATH=$(dirname `which $0`)

if [ ! -d $mDir ]; then	mkdir -p $mDir; fi
$SCRIPT_PATH/train_diagUBM.sh  $featFile $M $num_gselect $mDir || exit 1;
$SCRIPT_PATH/train_fullUBM.sh  $featFile $num_gselect $mDir $mDir/ubm || exit 1;
$SCRIPT_PATH/train_ivector_extractor.sh $ivector_dim $num_gselect $mDir/ubm/final.ubm $featFile $mDir/extractor || exit 1;
