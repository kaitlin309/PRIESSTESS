# PRIESSTESS

PRIESSTESS (Predictive RBP-RNA InterpretablE Sequence-Structure moTif regrESSion) is a universal RNA motif-finding method that is applicable to diverse *in vitro* RNA binding datasets. PRIESSTESS captures sequence specificity, structure specitifity, bipartite binding, and multiple distinct motifs.

PRIESSTESS consists of two steps. The first step generates a large collection of enriched motifs encompassing both RNA sequence and structure. The second step produces an aggregate model, which combines the motif scores into a single value, and gauges the relative importance of each motif. 

Laverty, K.U., Jolma, A., Pour, S.E., Zheng, H., Ray, D., Morris, Q.D., Hughes, T.R. PRIESSTESS: interpretable, high-performing models of the sequence and structure preferences of RNA binding proteins. *Nucleic Acids Research*. 2022 https://doi.org/10.1093/nar/gkac694

## Installation

Download PRIESSTESS and add path to main directory to bash profile. Ensure that the directory is named "PRIESSTESS".

### Requirements

RNAfold (PRIESSTESS was developed with version  2.4.11)

STREME (PRIESSTESS was developed with version  5.3.0)

python3 (PRIESSTESS was developed with version 3.8)

sklearn (PRIESSTESS was developed with version 0.23.2)

skopt python package (PRIESSTESS was developed with version  0.8.1)

**Note: A user of PRIESSTESS found that it would run only when the version of sklearn was dropped to 0.22.** See Issue: [#2](/../../issues/2)

## Usage

### Train a PRIESSTESS model 

  `PRIESSTESS -fg foreground_file -bg background_file [OPTIONS]`

The foreground_file and background_file must contain 1 probe sequence per line containing only characters A, C, G, U and N. Files must be either uncompressed or gzipped. To convert a fasta to the correct format use:
  
  `awk 'NR%2==0' fasta_file.fa > correct_format.txt`

#### OPTIONS

  `-h, --help`  Print help and exit

  `-o`          Path to existing output directory. A new directory called PRIESSTESS_output will be created in this directory to hold output. Default: current directory.

  `-f5`         5' constant flanking sequence to be added to 5' end of all probes in fg and bg files OR if -flanksIn flag is used can also be a number. Ex: GGAUUGUAACCUAUCUGUA OR 19    Default: None

  `-f3`         3' constant flanking sequence to be added to 3' end of all probes in fg and bg files OR if -flanksIn flag is used can also be a number. Ex: GGAUUGUAACCUAUCUGUA OR 19    Default: None

  `-flanksIn`   Indcates that 5' and 3' constant flanking sequences defined above are included in the probe sequences (-fg and -bg files). If the flag is not used, the flanks defined by -f5 and -f3 will be added by PRIESSTESS.

  `-t`          Folding temperature - passed to RNAfold. Default: 37

  `-alph`       Alphabet annotations to use in model. Default: 1,2,3,4,5,6,7    Ex. to use only the 1st & 4th alphabet type: 1,4

Alphabets annotations:

1: sequence (4-letter)

2: sequence-structure (8-letter) (4-letter sequence X 2-letter structure)

3: sequence-structure (16-letter) (4-letter sequence X 4-letter structure)

4: sequence-structure (28-letter) (4-letter sequence X 7-letter structure)

5: structure (2-letter)

6: structure (4-letter)

7: structure (7-letter)

  `-N`          The number of probes to use for PRIESSTESS from each of the forgeground and background files. This number will be aportioned between train and test sets. Default: The number of probes in the smaller two files.

  `-stremeP`    Percentage of probes to provide to STREME for enriched motif identification. Default: 50

  `-logregP`    Percentage of probes to use for training of the logistic regression model. Default: 25

  `-testingP`   Percentage of probes to hold out for testing. Default: 25

  `-minw`       Minimum motif width - passed to STREME. Width should be between 3 and 6. Default: 4

  `-maxw`       Maximum motif width - passed to STREME. Width should be between 6 and 9. Default: 6

  `-maxAmotifs` Maximum number of motifs per alphabet to be used to train logistic regression models. Should be between 1 and 99. Default: 40

  `-scoreN`     Number of motif hits to sum when scoring sequences. A value of 1 is equivalent to the max. Default: 4

  `-predLoss`   Loss of predictive power during simplification of logistic regression model, as percentage: final_AUROC = (initial_AUROC - 0.5)\*predLoss + 0.5. Should be between 1 and 99. Default: 10

  `-noCleanup`  Do not remove intermediate files created by PRIESSTESS. If this flag is not used intermediate files will be removed after usage
  
### Scanning with a PRIESSTESS model 

  `PRIESSTESS_scan -fg foreground_file -bg background_file [OPTIONS]`

The foreground_file and background_file must contain 1 probe sequence per line containing only characters A, C, G, U and N. Files must be either uncompressed or gzipped. To convert a fasta to the correct format use:
  
  `awk 'NR%2==0' fasta_file.fa > correct_format.txt`

#### OPTIONS

  `-h, --help`  Print help and exit

  `-p`          Path to PRIESSTESS_output directory containing the model to apply to the test data. Default: ./PRIESSTESS_output
  
  `-testName`   A name to use when creating directories and files with results. Ex. K562_RBFOX2_clip    Default: test_data

  `-f5`         5' constant flanking sequence to be added to 5' end of all probes in fg and bg files OR if -flanksIn flag is used can also be a number. Ex: GGAUUGUAACCUAUCUGUA OR 19    Default: None

  `-f3`         3' constant flanking sequence to be added to 3' end of all probes in fg and bg files OR if -flanksIn flag is used can also be a number. Ex: GGAUUGUAACCUAUCUGUA OR 19    Default: None

  `-flanksIn`   Indcates that 5' and 3' constant flanking sequences defined above are included in the probe sequences (-fg and -bg files). If the flag is not used, the flanks defined by -f5 and -f3 will be added by PRIESSTESS.

  `-t`          Folding temperature - passed to RNAfold. Default: 37

  `-noCleanup`  Do not remove intermediate files created by PRIESSTESS. If this flag is not used intermediate files will be removed after usage

