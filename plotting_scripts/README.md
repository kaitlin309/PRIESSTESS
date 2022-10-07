# Plotting Scripts

This directory contains scripts that can be used to visualize PRIESSTESS models.

## plot_PFMs_weights.R

This script creates plots displaying motifs and their associated model weights. See Figure 5 of the paper and the file `RC3H1_GA40NCTGATTAAND_motifs.pdf` in this directory for examples. 

Plot description: "Motif features from trained PRIESSTESS models are displayed in decreasing order based on the proportion of the total model weight, which is indicated below each motif. Motif features with zero weights are not shown."

The number of motifs in the plot is the minimum of: the number of motifs with non-zero weights in the model or 10 motifs.

#### Running the script

This script can be run from the command line. You will need provide the path to the directory containing the trained PRIESSTESS model (e.g. "PRIESSTESS_output") and a name for the resulting file without a file extension (e.g. "RBP_X_weights").

Format: `Rscript plot_PFMs_weights.R DIRECTORY/PATH FILENAME`

Example: `Rscript plot_PFMs_weights.R PRIESSTESS_output RBP_X_weights`

This will create a file named `RBP_X_weights.pdf` in the **present working directory**. 

#### Requirements

This is an R script and thus requries R, but also requires the installation of the following R packages:
- ggplot2
- ggseqlogo
- grid
- viridis

#### Legends

The plot output by this script does not contain a legend. The file `PFMs_and_weights_legend.pdf` contains legends for each of the structural alphabets and a legend for the proportion of total weight displayed below the motifs. These legends are applicable to ALL plots made with an unaltered version of this script.


