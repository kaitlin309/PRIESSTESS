import sys
import os
from argparse import ArgumentParser
import numpy as np

'''
This script takes an alphabet (alphabets defined below) and a fasta file (*.fa 
or *.fasta) and scans each sequence in the file using any PFMs in the same
directory with file names matching a provided prefix 
Scanning of a PFM of length L on a sequence of length N is done by scoring
each subsequence of length L from 1 to N-(L+1)
The score of each subsequence is the product of the PFM probabilities at each 
position for the alphabet letter at each position in the subsequence 
The final score for the entire sequence is the sum of the top N scores where
N is provided by the user

USAGE: 
    PFM_scan.py -a <alphabet> -f <fastafile> -p <PFMprefix> -t <topNscores>

    **ALL ARGUMENTS MUST BE PROVIDED**

  Arguments:
    -h,--help    Print help message
    -a,--alph    Alphabet used in the PFMs. Can be: seq-4, seq-struct-8, 
                 seq-struct-16, seq-struct-28, struct-2, struct-4, struct-7
    -f,--fasta   Path to uncompressed fasta with sequences to scan
    -p,--prefix  Prefix of the PFM files. Ex. to use files called PFM_1.txt
                 PFM_2.txt and PFM_3.txt use: PFM_
                 PFMs must be in the format position x alphabet letter. Ex:
                    A    0.1    0.2    0.9    0
                    C    0      0.3    0      1
                    G    0.8    0      0.1    0
                    U    0.1    0.5    0      0
    -n,--topN    Number of top subsequence scores to add for total sequence 
                 score. A value of 1 is equivalent to the max score.
OUTPUT: 
A single file in the current directory called:
        FF_PFM_scan_sum_top_N.tab
    - FF is the name of fasta file: /path/to/fasta/FF.fa
    - N is the number of subsequence scores added
File format:
seq_ID    PFM_file_name_1    PFM_file_name_2    ...
fg_1      0.923394           0.002589           ...
fg_2      0.000012           0.014342           ...
'''
# ALPHABET DEFINITIONS
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

# Alphabets with observation lists
alphabets = {'seq-4': {list('ACGU')[k]:k for k in range(4)},
             'struct-2': {list('PU')[k]:k for k in range(2)},
             'struct-4': {list('LMPU')[k]:k for k in range(4)},
             'struct-7': {list('BEHLMRT')[k]:k for k in range(7)},
             'seq-struct-8': {list(letters[0:8])[k]:k for k in range(8)},
             'seq-struct-16': {list(letters[0:16])[k]:k for k in range(16)},
             'seq-struct-28': {list(letters[0:28])[k]:k for k in range(28)}}

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-a", "--alph",
                        help="Alphabet used in the PFMs. Can be: seq-4, seq-struct-8, seq-struct-16, seq-struct-28, struct-2, struct-4, struct-7")
    parser.add_argument("-f", "--fasta",
                        help="Path to uncompressed fasta with sequences",
                        type=str)
    parser.add_argument("-p", "--prefix", type=str,
                        help="Prefix of the PFM files")
    parser.add_argument("-n", "--topN", type=int,
                        help="Number of top subsequence scores to add for total sequence score")

    args = parser.parse_args()

    # Assumes suffix is .fa or .fasta
    if ".fasta" in args.fasta:
        out_prefix = args.fasta[:-6]
    else: 
        out_prefix = args.fasta[:-3]
    # Remove path
    out_prefix = out_prefix.split("/")[-1]
    
    # Read in PFMs
    PFMdir = '/'.join(args.prefix.split("/")[:-1])
    if PFMdir == '':
        PFMdir = '.'
    PFMprefix = args.prefix.split("/")[-1]

    PFM_dir_files = os.listdir(PFMdir)
    PFMs = dict()
    PFM_names = []
    for p in PFM_dir_files:
        if p.startswith(PFMprefix):
            PFM_name = '.'.join(p.split('.')[:-1])
            PFM_file = open(PFMdir + '/' + p, 'r')
            lines = PFM_file.readlines()
            PFM_file.close()
            PFM = []
            for line in lines:
                PFM.append([float(i) for i in line.strip().split('\t')[1:]])
            PFMs[PFM_name] = np.array(PFM).T
            PFM_names.append(PFM_name)

    outfile = open(out_prefix+'_PFM_scan_sum_top_'+str(args.topN)+'.tab', 'w')
    outfile.write('seq_id\t'+'\t'.join(PFM_names)+'\n')

    with open(args.fasta) as f:
        for line in f:
            seq_id=line.strip()[1:]
            sequence = next(f)
            sequence = sequence.strip()
            sequence_scores = []
            for pn in PFM_names:
                p = PFMs[pn]
                if len(sequence) < len(p)+args.topN-1:
                    subseqscores = [0]
                else:
                    subseqscores = []
                    for i in range(1+len(sequence)-len(p)):
                        subseq = sequence[i:(i+len(p))]
                        subseqscores.append(np.prod(p[range(len(p)), [alphabets[args.alph][j] for j in subseq]]))                
                sequence_scores.append(sum(np.sort(subseqscores)[-args.topN:]))
            outfile.write(seq_id+'\t'+'\t'.join([str(i) for i in sequence_scores])+'\n')

    outfile.close()

