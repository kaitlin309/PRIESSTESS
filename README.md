# PRIESSTESS

PRIESSTESS (Predictive RBP-RNA InterpretablE Sequence-Structure moTif regrESSion) is a universal RNA motif-finding method that is applicable to diverse *in vitro* RNA binding datasets. PRIESSTESS captures sequence specificity, structure specitifity, bipartite binding, and multiple distinct motifs.

PRIESSTESS consists of two steps. The first step generates a large collection of enriched motifs encompassing both RNA sequence and structure. The second step produces an aggregate model, which combines the motif scores into a single value, and gauges the relative importance of each motif. 

Laverty, K.U., Jolma, A., Pour, S., Zheng, H., Ray, D., Morris, Q.D., Hughes, T.R. PRIESSTESS: interpretable, high-performing models of the sequence and structure preferences of RNA binding proteins. 

## Installation

### Requirements

RNAfold (PREISSTESS was developed with version  2.4.11)
STREME (PREISSTESS was developed with version  5.3.0)
python3 (PREISSTESS was developed with version 3.8)
skopt python package (PREISSTESS was developed with version  0.8.1)

## Usage

To train a PRIESSTESS model run PRIESSTESS
