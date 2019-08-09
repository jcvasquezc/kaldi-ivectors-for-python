#!/bin/bash
# Copyright     2013  Daniel Povey
#               2014  David Snyder
# Apache 2.0.

# Modified by Copyright 2017 Nicanor Garcia-Ospina
# Modified by Copyright 2019 Juan Camilo Vasquez-Correa
# Apache 2.0.

# This script extracts iVectors for a set of utterances, given
# features and a trained iVector extractor.

# Begin configuration section.
nj=4
num_gselect=20 # Gaussian-selection using diagonal model: number of Gaussians to select
min_post=0.025 # Minimum posterior to use (posteriors below this are pruned out)
posterior_scale=1.0 # This scale helps to control for successve features being highly
                    # correlated.  E.g. try 0.1 or 0.3.
# End configuration section.

echo "$0 $@"  # Print the command line for logging

SCRIPT_PATH=$(dirname `which $0`)
if [ -f path.sh ]; then . $SCRIPT_PATH/path.sh; fi
$SCRIPT_PATH/parse_options.sh || exit 1;

num_gselect=$1
srcdir=$2
features=$3
dir=$4

if [ -f $dir/ivector.scp ]; then
	exit 0;
fi

for f in $srcdir/final.ie $srcdir/final.ubm ${features} ; do
  [ ! -f $f ] && echo "No such file $f" && exit 1;
done

# Set various variables.
mkdir -p $dir/log

delta_opts=`cat $srcdir/delta_opts 2>/dev/null`

## Set up features.
feats="ark:copy-matrix scp:${features} ark:- |"

  echo "$0: extracting iVectors"
  dubm="fgmm-global-to-gmm $srcdir/final.ubm -|"

gmm-gselect --n=$num_gselect "$dubm" "$feats" ark:- | \
fgmm-global-gselect-to-post --min-post=$min_post $srcdir/final.ubm "$feats" \
 ark:- ark:- | scale-post ark:- $posterior_scale ark:- | \
  ivector-extract --verbose=2 $srcdir/final.ie "$feats" ark:- \
  ark,scp:$dir/ivector.ark,$dir/ivector.scp || exit 1;
