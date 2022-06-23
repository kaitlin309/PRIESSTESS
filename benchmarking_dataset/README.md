# Benchmarking Dataset

This directory contains the benchmarking dataset and associated files across three directories. Details on the files in each directory are provided below.

## train_and_test_sets/

This directory contains the train and test sets for each of the 55 experiments in the benchmarking dataset. Details on each experiment can be found in `train_and_test_sets/Experiment.Info.csv`. Further information is available in the paper supplement. 

The data for each experiment is split into 4 files:

- `EXPERIMENTID_positive_trainset.txt`
- `EXPERIMENTID_positive_testset.txt`
- `EXPERIMENTID_negative_trainset.txt`
- `EXPERIMENTID_negative_testset.txt`

The datasets are split in this manner to facilitate comparison to other methods, as these are the exact train and test splits for PRIESSTESS models that are shown in the paper. Note that sequences in these files contain 5' and 3' flanking sequences that were used in the experiment (if any).

To reapply PRIESSTESS to this, the files for a given experiment must be combined into 2 files as follows:

```
cat EXPERIMENTID_positive_trainset.txt EXPERIMENTID_positive_testset.txt > EXPERIMENTID_positive_set.txt
cat EXPERIMENTID_negative_trainset.txt EXPERIMENTID_negative_testset.txt > EXPERIMENTID_negative_set.txt
```

Note that reapplication of PRIESSTESS to these datasets will lead to different train-test splits than those in the files within this directory.

#### Example

To rerun PRIESSTESS for the experiment TGGACT40NAATEMJ (ELAVL1, HTR-SELEX data from Jolma *et al.* 2020):

```
cat TGGACT40NAATEMJ_positive_trainset.txt TGGACT40NAATEMJ_positive_testset.txt > TGGACT40NAATEMJ_positive_set.txt
cat TGGACT40NAATEMJ_negative_trainset.txt TGGACT40NAATEMJ_negative_testset.txt > TGGACT40NAATEMJ_negative_set.txt
PRIESSTESS -fg TGGACT40NAATEMJ_positive_set.txt -bg TGGACT40NAATEMJ_negative_set.txt -flanksIn -f5 47 -f3 58 -t 37
```

`-flanksIn` indicates that flanking sequences are already included in the sequences within the provided files, `-f5` and `-f3` provide the lengths of the 5' and 3' flanking sequences, respectively, and `-t` provides the folding temperature.

Information on flanking sequences and folding temperatures can be found for all benchmarking dataset experiments in `train_and_test_sets/Experiment.Info.csv`.

## clip_data/

This directory contains the CLIP data used for testing in Laverty _et al._ Details on each experiment can be found in `clip_data/CLIP.Experiment.Info.csv`. Further information is available in the paper supplement. Each CLIP experiment is associated with two files, the positive and negative sets:

- `CLIPEXPERIMENT_negative_clip_set.txt`
- `CLIPEXPERIMENT_positive_clip_set.txt`

The file `clip_data/Benchmarking.Dataset.Exp.CLIP.Pairs.csv` details which experiments in the benchmarking dataset were tested on which CLIP experiments. For example, the eCLIP experiment ENCFF871NYM was performed on RBFOX2 in HepG2 cells (this information is in `clip_data/CLIP.Experiment.Info.csv`), and is used for testing the three benchmarking dataset experiments for RBFOX1 and RBFOX2: ENCFF002DHF (RBNS), TTGCGA40NTACGAAG (HTR-SELEX Jolma _et al._), TC40NAATCTCAAUC (HTR-SELEX Laverty _et al._). The follownig three lines in `clip_data/Benchmarking.Dataset.Exp.CLIP.Pairs.csv` show this:

```
ENCFF002DHF,ENCFF871NYM
TTGCGA40NTACGAAG,ENCFF871NYM
TC40NAATCTCAAUC,ENCFF871NYM
```

## scores/

This directory contains the scores of the 55 trained benchmarking dataset PRIESSTESS models presented in Laverty _et al._ on all test data. File names describe the file contents as follows:

`BENCHMARKINGEXPERIMENT_PRIESSTESS_ON_TESTEXPERIMENT_TYPE_scores.txt.gz`

Where `BENCHMARKINGEXPERIMENT` is one of the 55 benchmarking dataset experiment UIDs (see `train_and_test_sets/Experiment.Info.csv`) and `TESTEXPERIMENT` is one of the 55 benchmarking dataset experiment UIDs or one of the 26 CLIP experiment UIDs (see `clip_data/CLIP.Experiment.Info.csv`), and `TYPE` is either "testset" (if it is a benchmarking experiment) or "clip" (if it is a CLIP experiment).

For the benchmarking dataset experiment ENCFF002DHF (RBFOX2, RBNS), there are 5 files with scores for the PRIESSTESS model trained on this data.

| File name                                                       | Test data                  | Testing type (in Laverty _et al._)         |
| --------------------------------------------------------------- | -------------------------- | ------------------------------------------ |
| `ENCFF002DHF_PRIESSTESS_ON_ENCFF002DHF_testset_scores.txt`      | ENCFF002DHF test data      | Held-out data same experiment              |
| `ENCFF002DHF_PRIESSTESS_ON_ENCFF206RIM_clip_scores.txt`         | ENCFF206RIM clip data      | CLIP data                                  |
| `ENCFF002DHF_PRIESSTESS_ON_ENCFF871NYM_clip_scores.txt`         | ENCFF871NYM clip data      | CLIP data                                  |
| `ENCFF002DHF_PRIESSTESS_ON_TC40NAATCTCAAUC_testset_scores.txt`  | TC40NAATCTCAAUC test data  | Held-out data, other _in vitro_ experiment |
| `ENCFF002DHF_PRIESSTESS_ON_TTGCGA40NTACGAAG_testset_scores.txt` | TTGCGA40NTACGAAG test data | Held-out data, other _in vitro_ experiment |

Files are tab-delimited, containing on each line a 1 or 0 (indicating positive or negative set) and a score. These can be directly associated with files in `train_and_test_sets/` and `clip_data/`. For example, the ENCFF002DHF positive test set file in `train_and_test_sets/` contains 250,000 lines and the negative test set file contains 250,000. The file `ENCFF002DHF_PRIESSTESS_ON_ENCFF002DHF_testset_scores.txt` contains 500,000 lines, the first half contain the scores for the sequences in the positive test set and the second half contain the scores for the negative test set sequences. Line by line, scores match the sequences in the test set files.

Similarly, `ENCFF002DHF_PRIESSTESS_ON_ENCFF871NYM_clip_scores.txt` contains 14,954 lines and `clip_data/ENCFF871NYM_positive_clip_set.txt` and `clip_data/ENCFF871NYM_negative_clip_set.txt` each contain 7,477 sequences. To directly associate sequences with scores:

`cat clip_data/ENCFF871NYM_positive_clip_set.txt clip_data/ENCFF871NYM_negative_clip_set.txt | paste ENCFF002DHF_PRIESSTESS_ON_ENCFF871NYM_clip_scores.txt -`


