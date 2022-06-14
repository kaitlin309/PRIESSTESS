# Benchmarking Dataset

This directory contains the benchmarking dataset. Details on each of the 55 experiments can be found in Experiment.Info.csv. Further information is available in the paper supplement.

The data for each experiment is split into 4 files:

- `EXPERIMENTID_positive_training_set.txt`
- `EXPERIMENTID_positive_testing_set.txt`
- `EXPERIMENTID_negative_training_set.txt`
- `EXPERIMENTID_negative_testing_set.txt`

The datasets are split in this manner to facilitate comparison to other methods, as these are the exact train and test splits for models that are shown in the paper.
However, to reapply PRIESSTESS to this data, the files for a given experiment must be combined into 2 files as follows:

`cat EXPERIMENTID_positive_training_set.txt EXPERIMENTID_positive_testing_set.txt > EXPERIMENTID_positive_set.txt`

`cat EXPERIMENTID_negative_training_set.txt EXPERIMENTID_negative_testing_set.txt > EXPERIMENTID_negative_set.txt`

#### Notes
Reapplication of PRIESSTESS to these datasets will lead to different train-test splits than those in these files.

Files contain any 5' and 3' flanking sequences that used in the experiment.

#### Example

To rerun PRIESSTESS for the experiment TGGACT40NAATEMJ (ELAVL1, HTR-SELEX data from Jolma *et al.* 2020):

`PRIESSTESS `

