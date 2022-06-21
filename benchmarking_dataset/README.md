# Benchmarking Dataset

This directory contains the benchmarking dataset and associated files across three directories. Details on the files in each directory are provided below.

## train_and_test_sets/

This directory contains the train and test sets for each of the 55 experiments in the benchmarking dataset. Details on each experiment can be found in `Experiment.Info.csv`. Further information is available in the paper supplement. 

The data for each experiment is split into 4 files:

- `EXPERIMENTID_positive_trainset.txt`
- `EXPERIMENTID_positive_testset.txt`
- `EXPERIMENTID_negative_trainset.txt`
- `EXPERIMENTID_negative_testset.txt`

The datasets are split in this manner to facilitate comparison to other methods, as these are the exact train and test splits for PRIESSTESS models that are shown in the paper. Note that sequences in these files contain 5' and 3' flanking sequences that were used in the experiment (if any).

To reapply PRIESSTESS to this, the files for a given experiment must be combined into 2 files as follows:

`cat EXPERIMENTID_positive_trainset.txt EXPERIMENTID_positive_testset.txt > EXPERIMENTID_positive_set.txt`

`cat EXPERIMENTID_negative_trainset.txt EXPERIMENTID_negative_testset.txt > EXPERIMENTID_negative_set.txt`

Note that reapplication of PRIESSTESS to these datasets will lead to different train-test splits than those in the files within this directory.

#### Example

To rerun PRIESSTESS for the experiment TGGACT40NAATEMJ (ELAVL1, HTR-SELEX data from Jolma *et al.* 2020):

`cat TGGACT40NAATEMJ_positive_trainset.txt TGGACT40NAATEMJ_positive_testset.txt > TGGACT40NAATEMJ_positive_set.txt`

`cat TGGACT40NAATEMJ_negative_trainset.txt TGGACT40NAATEMJ_negative_testset.txt > TGGACT40NAATEMJ_negative_set.txt`

`PRIESSTESS -fg TGGACT40NAATEMJ_positive_set.txt -bg TGGACT40NAATEMJ_negative_set.txt -flanksIn -f5 47 -f3 58 -t 37`

`-flanksIn` indicates that flanking sequences are already included in the sequences within the provided files, `-f5` and `-f3` provide the lengths of the 5' and 3' flanking sequences, respectively, and `-t` provides the folding temperature.

Information on flanking sequences and folding temperatures can be found for all benchmarking dataset experiments in `Experiment.Info.csv`.

## clip_data/

## scores/



