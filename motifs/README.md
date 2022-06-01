# PRIESSTESS model motifs

Motifs with non-zero weights in each PRIESSTESS model trained for Laverty *et al.* 2022 are contained within this directory. The subdirectory contents are as follows:

| Directory                     | Contents                                                        |
| ----------------------------- | --------------------------------------------------------------- |
| `RBNS_motifs`                 | PFMs from models trained on RNA Bind-n-Seq datasets             |
| `HTRSELEX_Jolma_motifs`       | PFMs from models trained on all HTRSELEX from Jolma et al. 2020 |
| `benchmarking_dataset_motifs` | PFMs from models trained on the benchmarking data               |

File names describe the experiment identifier, the alphabet annotation of the PFM, the rank of significance of the PFM as discovered by STREME, and the weight of the PFM as a feature in the LR model.

For example, in `benchmarking_motifs` there are three files containing the three PFMs with non-zero weights in the PRIESSTESS model for the experiment RNACS001 (QKI - RNAcompete-S):

`RNACS001_seq-4_PFM-2_0.39486794296553107.txt`\
`RNACS001_seq-struct-8_PFM-2_0.22565915591489286.txt`\
`RNACS001_seq-struct-8_PFM-8_0.01572753823855386.txt`

The first of these files is a sequence-only PFM (ACGU), the second and third are sequence-structure motifs from the 8-letter sequence-structure alphabet (each alphabet is described in detail below). The second and third PFM files contain "PFM-2" and "PFM-8", respectively, indicating that they were the 2nd and 8th motifs identified by STREME. Each file ends in a number (ex. 0.39486794296553107) which is the weight of the PFM as a feature in the PRIESSTESS model.

Note that all identifiers can be matched to experiments using the "Exp.UID" columns in Supplementary Tables 3-6.

---

## Annotation Alphabets

### seq-4 
This is the standard RNA sequence annotation.

A\
C\
G\
U

### struct-2
This is a structure-only annotation that differentiates between paired and unpaired bases.

U - unpaired\
P - paired

### struct-4
This is a structure-only annotation that differentiates between 3 different types of unpaired base.

P - paired\
L - hairpin loop\
U - external\
M - other loops (multi-loop / internal loop / bulge)

### struct-7
This is a structure-only annotation that differentiates 7 different types of structure.

B - bulge\
E - external\
H - hairpin\
L - left paired\
M - multi-loop\
R - right paired\
T - internal loop

### seq-struct-8
This is a sequence-structure annotation that combines seq-4 and struct-2. Note A + U indicates an unpaired adenine.

A - A + U\
B - A + P\
C - C + U\
D - C + P\
E - G + U\
F - G + P\
G - U + U\
H - U + P
  
### seq-struct-16
This is a sequence-structure annotation that combines seq-4 and struct-4. Note A + P indicates a paired adenine.

A - A + P\
B - A + L\
C - A + U\
D - A + M\
E - C + P\
F - C + L\
G - C + U\
H - C + M\
I - G + P\
J - G + L\
K - G + U\
L - G + M\
M - U + P\
N - U + L\
O - U + U\
P - U + M
  
### seq-struct-28
This is a sequence-structure annotation that combines seq-4 and struct-7. Note A + B indicates an adenine in a bulge.

A - A + B\
B - A + E\
C - A + H\
D - A + L\
E - A + M\
F - A + R\
G - A + T\
H - C + B\
I - C + E\
J - C + H\
K - C + L\
L - C + M\
M - C + R\
N - C + T\
O - G + B\
P - G + E\
Q - G + H\
R - G + L\
S - G + M\
T - G + R\
U - G + T\
V - U + B\
W - U + E\
X - U + H\
Y - U + L\
Z - U + M\
a - U + R\
b - U + T

---
