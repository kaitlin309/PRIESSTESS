# Benchmarking Dataset

This directory contains the benchmarking dataset. Details on each of the 55 experiments can be found in `Experiment.Info.csv`. Further information is available in the paper supplement. Note that sequences in these files contain 5' and 3' flanking sequences that were used in the experiment (if any).

The data for each experiment is split into 4 files:

- `EXPERIMENTID_positive_training_set.txt`
- `EXPERIMENTID_positive_testing_set.txt`
- `EXPERIMENTID_negative_training_set.txt`
- `EXPERIMENTID_negative_testing_set.txt`

The datasets are split in this manner to facilitate comparison to other methods, as these are the exact train and test splits for PRIESSTESS models that are shown in the paper.
However, to reapply PRIESSTESS to this data, the files for a given experiment must be combined into 2 files as follows:

`cat EXPERIMENTID_positive_training_set.txt EXPERIMENTID_positive_testing_set.txt > EXPERIMENTID_positive_set.txt`

`cat EXPERIMENTID_negative_training_set.txt EXPERIMENTID_negative_testing_set.txt > EXPERIMENTID_negative_set.txt`

Note that reapplication of PRIESSTESS to these datasets will lead to different train-test splits than those in the files within this directory.

#### Example

To rerun PRIESSTESS for the experiment TGGACT40NAATEMJ (ELAVL1, HTR-SELEX data from Jolma *et al.* 2020):

`cat TGGACT40NAATEMJ_positive_training_set.txt TGGACT40NAATEMJ_positive_testing_set.txt > TGGACT40NAATEMJ_positive_set.txt`

`cat TGGACT40NAATEMJ_negative_training_set.txt TGGACT40NAATEMJ_negative_testing_set.txt > TGGACT40NAATEMJ_negative_set.txt`

`PRIESSTESS -fg TGGACT40NAATEMJ_positive_set.txt -bg TGGACT40NAATEMJ_negative_set.txt -flanksIn -f5 47 -f3 58 -t 37`

`-flanksIn` indicates that flanking sequences are already included in the sequences within the provided files, `-f5` and `-f3` provide the lengths of the 5' and 3' flanking sequences, respectively, and `-t` provides the folding temperature.

Information on flanking sequences and folding temperatures can be found for all benchmarking dataset experiments in `Experiment.Info.csv`.
