#!/bin/bash
NUM_THREADS=4

FA=$1

OUT=${FA/.fa/}".salmon_idx"
if [ ! -e $OUT ]; then
  echo "Create $OUT"
  salmon index -p $NUM_THREADS -t $FA -i $OUT
fi
