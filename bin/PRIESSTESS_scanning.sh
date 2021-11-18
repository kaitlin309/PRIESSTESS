#!/bin/bash

# Establish package installation location
#libpath=`whereis PRIESSTESS`
libpath=/scratch/q/qmorris/klaverty/PRIESSTESS/bin

#### ARGUMENTS ####
# -----------------------------------------------------------------------------#
# Argument default values
out_dir="."                     # -o
pr_model="PRIESSTESS_output"    # -pm
flank5=""                       # -f5
flank3=""                       # -f3
flanks_included="FALSE"		# -flanksIn
temp=37                         # -t
clean="TRUE"			# -noCleanup

# Read in arguments and save
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "USAGE:"
            echo "  PRIESSTESS -fg foreground_file -bg background_file [OPTIONS]"
            echo ""
            echo "    foreground_file and background_file must contain 1 probe"
            echo "    sequence per line containing only characters A, C, G, U "
            echo "    and N"
            echo "    Files must be either uncompressed or gzipped"
            echo "    To convert a fasta to the correct format use:"
            echo "        awk 'NR%2==0' fasta_file.fa > correct_format.txt"
            echo ""
            echo "OPTIONS:"
            echo "  -h, --help  Print help and exit"
            echo ""
            echo "  -o          Path to existing output directory"
            echo "                A new directory called PRIESSTESS_output"
            echo "                will be created in this directory to hold"
            echo "                output"
            echo "                Default: current directory"
            echo ""
            echo "  -f5         5' constant flanking sequence to be added to"
            echo "                5' end of all probes in fg and bg files"
            echo "                OR if -flanksIn flag is used can also be a"
            echo "                number"
            echo "                Ex: GGAUUGUAACCUAUCUGUA OR 19"
            echo "                Default: None"
            echo ""
            echo "  -f3         3' constant flanking sequence to be added to"
            echo "                3' end of all probes in fg and bg files"
            echo "                OR if -flanksIn flag is used can also be a"
            echo "                number"
            echo "                Ex: GGAUUGUAACCUAUCUGUA OR 19"
            echo "                Default: None"
            echo ""
            echo "  -flanksIn   Indcates that 5' and 3' constant flanking "
            echo "                sequences defined above are included in the"
            echo "                probe sequences (-fg and -bg files)"
            echo "                If the flag is not used, the flanks defined"
            echo "                by -f5 and -f3 will be added by PRIESSTESS"
            echo ""
            echo "  -t          Folding temperature - passed to RNAfold"
            echo "                Default: 37"
            echo ""
            echo "  -alph       Alphabet annotations to use in model"
            echo "                Default: 1,2,3,4,5,6,7"
            echo "                Ex. to use only the 1st & 4th alphabet type:"
            echo "                  1,4"
            echo "                Alphabets annotations:"
            echo "                  1: sequence (4-letter)"
            echo "                  2: sequence-structure (8-letter)"
            echo "                      4-letter sequence X 2-letter structure"
            echo "                  3: sequence-structure (16-letter)"
            echo "                      4-letter sequence X 4-letter structure"
            echo "                  4: sequence-structure (28-letter)"
            echo "                      4-letter sequence X 7-letter structure"
            echo "                  5: structure (2-letter)"
            echo "                  6: structure (4-letter)"
            echo "                  7: structure (7-letter)"
            echo ""
            echo "  -N          The number of probes to use for PRIESSTESS from"
            echo "                each of the -fg and -bg files"
            echo "                This number will be aportioned between train"
            echo "                and test sets"
            echo "                Default: The number of probes in the smaller"
            echo "                         of -fg and -bg files"
            echo ""
            echo "  -stremeP    Percentage of probes to provide to STREME for"
            echo "                enriched motif identification"
            echo "                Default: 50"
            echo ""
            echo "  -logregP    Percentage of probes to use for training of the"
            echo "                logistic regression model"
            echo "                Default: 25"
            echo ""
            echo "  -testingP   Percentage of probes to hold out for testing"
            echo "                Default: 25"
            echo ""
            echo "  -minw       Minimum motif width - passed to STREME"
            echo "                Width should be between 3 and 6"
            echo "                Default: 4"
            echo ""
            echo "  -maxw       Maximum motif width - passed to STREME"
            echo "                Width should be between 6 and 9"
            echo "                Default: 6"
            echo ""
            echo "  -maxAmotifs Maximum number of motifs per alphabet to be"
            echo "                used to train logistic regression models"
            echo "                Should be between 1 and 99"
            echo "                Default: 40"
            echo ""
            echo "  -scoreN     Number of motif hits to sum when scoring"
            echo "                sequences"
            echo "                A value of 1 is equivalent to the max"
            echo "                Default: 4"
            echo ""
            echo "  -predLoss   Loss of predictive power during simplification"
            echo "                of logistic regression model, as percentage"
            echo "                final_AUROC = (initial_AUROC - 0.5)*predLoss + 0.5"
            echo "                Should be between 1 and 99"
            echo "                Default: 10"
            echo ""
            echo "  -noCleanup  Do not remove intermediate files created by"
            echo "                PRIESSTESS"
            echo "                If this flag is not used intermediate files"
            echo "                will be removed after usage"
            echo ""
            exit 0
            ;;
        -fg)
            shift
            if [ ! -f $1 ]; then echo "-fg: file $1 does not exist"; exit 1; fi;
            if [[ $1 =~ \.gz$ ]]; then 
                n=`zcat $1 | grep -v "[ACGUN]*" | wc -l`
                if [[ $n -gt 0 ]]; then
                    echo "-fg: file should only contain: A,C,G,U,N"
                    exit 1
                fi
                n=`zcat $1 | wc -l`
                if [[ $n -lt 1000 ]]; then
                    echo "-fg: file should contain at least 1000 sequences"
                    exit 1
                fi
            else
                n=`grep -v "[ACGUN]*" $1 | wc -l`
                if [[ $n -gt 0 ]]; then
                    echo "-fg: file should only contain: A,C,G,U,N"
                    exit 1
                fi
                n=`cat $1 | wc -l`
                if [[ $n -lt 1000 ]]; then
                    echo "-fg: file should contain at least 1000 sequences"
                    exit 1
                fi
            fi
            fgfile=$1
            shift
            ;;
        -bg)
            shift
            if [ ! -f $1 ]; then echo "-bg: file $1 does not exist"; exit 1; fi;
            if [[ $1 =~ \.gz$ ]]; then 
                n=`zcat $1 | grep -v "[ACGUN]*" | wc -l`
                if [[ $n -gt 0 ]]; then
                    echo "-bg: file can only contain: A,C,G,U,N"
                    exit 1
                fi
                n=`zcat $1 | wc -l`
                if [[ $n -lt 1000 ]]; then
                    echo "-bg: file should contain at least 1000 sequences"
                    exit 1
                fi
            else
                n=`grep -v "[ACGUN]*" $1 | wc -l`
                if [[ $n -gt 0 ]]; then
                    echo "-bg: file can only contain: A,C,G,U,N"
                    exit 1
                fi
                n=`cat $1 | wc -l`
                if [[ $n -lt 1000 ]]; then
                    echo "-bg: file should contain at least 1000 sequences"
                    exit 1
                fi
            fi
            bgfile=$1
            shift
            ;;
        -o)
            shift
            if [ ! -d $1 ]; then
                echo "-o: output directory provided does not exist"
                exit 1
            fi
            out_dir=$1
            shift
            ;; 
        -f5)
            shift
            if [[ ! "$1" =~ ^[ACGU]*$ ]]; then
                if [[ ! "$1" =~ ^[0-9][0-9]*$ ]]; then
                    echo "-f5: 5' flank sequence can only contain: A,C,G,U"
                    echo "     or be a integer" 
                    exit 1
                fi
            fi
            flank5=$1
            shift
            ;;
        -f3)
            shift
            if [[ ! "$1" =~ ^[ACGU]*$ ]]; then
                if [[ ! "$1" =~ ^[0-9][0-9]*$ ]]; then
                    echo "-f3: 3' flank sequence can only contain: A,C,G,U"
                    echo "     or be a integer" 
                    exit 1
                fi
            fi
            flank3=$1
            shift
            ;;
        -flanksIn)
            flanks_included="TRUE"
            shift
            ;;
        -t)
            shift
            if [[ ! "$1" =~ ^[1-9][0-9]*$ ]]; then
                echo "-t: temperature must be int"
                exit 1
            fi
            temp=$1
            shift
            ;;
        -alph)
            shift
            n=`echo $1 | wc -c`
            n=$(( n - 1 ))
            if [[ $n -lt 1 ]]; then 
                echo "-alph: at leaste one alphabet must be chosen"
            fi
            if [[ ! "$1" =~ ^[1,]?[2,]?[3,]?[4,]?[5,]?[6,]?[7,]?$ ]]; then
                echo "-alph: alphabet choice must be in format: 1,2,3,4,5,6,7"
                echo "       Numbers must be in increasing order, comma"
                echo "       separated, without any spaces. Ex. 1,3,6"
                exit 1
	    fi;
	    alph=$1
	    shift
	    ;;
        -N)
            shift
            if [[ ! "$1" =~ ^[1-9][0-9][0-9][0-9][0-9]*$ ]]; then
                echo "-N: The number of probes must be an int > 1000"
                exit 1
            fi
            N=$1
            shift
            ;;
        -stremeP)
            shift
            if [[ ! "$1" =~ ^[1-9][0-9]?$ ]]; then
                echo "-stremeP: % data used for STREME must be int > 0 & < 100"
                exit 1
            fi
            streme_perc=$1
            shift
            ;;
        -logregP)
            shift
            if [[ ! "$1" =~ ^[1-9][0-9]?$ ]]; then
                echo "-logregP: % data used for LR must be int > 0 & < 100"
                exit 1
            fi
            LR_perc=$1
            shift
            ;;
        -testP)
            shift
            if [[ ! "$1" =~ ^[1-9][0-9]?$ ]]; then
                echo "-testeP: % data used for testing must be int > 0 & < 100"
                exit 1
            fi
            test_perc=$1
            shift
            ;;
        -minw)
            shift
            if [[ ! "$1" =~ ^[3-6]$ ]]; then
                echo "-minw: Minimum motif width should be between 3 and 6"
                exit 1
            fi
            min_width=$1
