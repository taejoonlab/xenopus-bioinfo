#!/bin/bash

NUM_THREADS=4

# Assume that you install trimmomatic with conda
#
# https://anaconda.org/bioconda/trimmomatic
#
# $ conda install -c bioconda trimmomatic

# Directory for conda
DIR_CONDA=$HOME/miniconda3

## For TruSeq
FA_ADAPTER=$( find $DIR_CONDA | grep -m1 TruSeq3-PE.fa )

## For Nextera (Tn5)
#FA_ADAPTER=$( find $DIR_CONDA | grep -m1 NexteraPE-PE.fa )

## List of adapters
#NexteraPE-PE.fa
#TruSeq2-PE.fa
#TruSeq2-SE.fa
#TruSeq3-PE-2.fa
#TruSeq3-PE.fa

echo "Adapter: "$FA_ADAPTER
cp $FA_ADAPTER .

for FQ1 in $(ls *R1.raw.fastq.gz)
do
  FQ2=${FQ1/_R1/_R2}
  OUT=${FQ1/_R1.raw.fastq.gz}"_trim"
  echo $FQ1 $FQ2 $OUT

  # ILLUMINACLIP:<fastaWithAdaptersEtc>:<seed mismatches>:<palindrome clip threshold>:<simple clip threshold> 
  #   fastaWithAdaptersEtc: specifies the path to a fasta file containing all the adapters,
  #       PCR sequences etc. The naming of the various sequences within this file determines
  #       how they are used. 
  #   seedMismatches: specifies the maximum mismatch count which will still allow a full
  #       match to be performed palindromeClipThreshold: specifies how accurate the match 
  #       between the two 'adapter ligated' reads must be for PE palindrome read alignment.
  #   simpleClipThreshold: specifies how accurate the match between any adapter etc.
  #       sequence must be against a read.
  #
  # SLIDINGWINDOW:<windowSize>:<requiredQuality> 
  #   windowSize: specifies the number of bases to average across.
  #   requiredQuality: specifies the average quality required.
  #
  # LEADING:<quality> Specifies the minimum quality required to keep a base.
  # TRAILING:<quality> Specifies the minimum quality required to keep a base.
  # MINLEN:<length>  Specifies the minimum length of reads to be kept.

  trimmomatic PE -validatePairs -threads $NUM_THREADS -summary $OUT".summary" $FQ1 $FQ2 -baseout $OUT \
   ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
done

