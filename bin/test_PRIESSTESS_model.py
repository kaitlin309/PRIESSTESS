import warnings
warnings.filterwarnings('ignore')
import sys
import os
import pickle
import numpy as np
from sklearn.metrics import roc_auc_score
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler

trainfile = sys.argv[1]
testfile = sys.argv[2]
trainmodel = sys.argv[3]
test_name = sys.argv[4]

# Load in data
trainset = np.loadtxt(trainfile, delimiter='\t', skiprows=1)
testset = np.loadtxt(testfile, delimiter='\t', skiprows=1)

# Get column names
with open(trainfile) as f:
    traincols=next(f)
traincols = np.array(traincols.strip().split('\t')[1:])
with open(testfile) as f:
    testcols=next(f)
testcols = np.array(testcols.strip().split('\t')[1:])

indmask = []
for i in traincols:
    indmask.append(np.where(testcols == i)[0][0])
indmask = np.array(indmask)

Xtrain = trainset[:, 1:len(trainset[0])]
Xtest = testset[:, 1:len(testset[0])]
Xtest = Xtest[:, indmask]
Ytest = testset[:, 0]

# Scale test values to the same scale as training values
scaler = StandardScaler()
scaler.fit(Xtrain)
Xtest = scaler.transform(Xtest)

# Load in the model
lr = pickle.load(open(trainmodel, 'rb'))

# Calculate AUROC
auroc = roc_auc_score(Ytest, lr.predict_proba(Xtest)[:,1])

# Write AUROC to file
outprefix="test_"+trainmodel.split('/')[-1][:-4]
ifile = open(outprefix+'_ON_'+test_name+'_auroc.tab', 'w')
ifile.write(str(auroc)+'\n')
ifile.close()

