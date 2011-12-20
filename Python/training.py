##This is a free software project named "SENSEable Shoes".
##Copyright (C) 2011 by Yen-Chia Hsu, CoDe LAB, Carnegie Mellon University, U.S.A.
##
##Permission is hereby granted, free of charge, to any person obtaining a copy of
##this software and associated documentation files (the "Software"), to deal in
##the Software without restriction, including without limitation the rights to
##use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
##of the Software, and to permit persons to whom the Software is furnished to do
##so, subject to the following conditions:
##
##The above copyright notice and this permission notice shall be included in all
##copies or substantial portions of the Software.
##
##THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##SOFTWARE.

import copy
import numpy as np
import importFile as im
import matplotlib.pyplot as plt
from matplotlib.ticker import EngFormatter
import config as cf

#### principle component analysis
def PCA(dataset, threshold):
    print "principle component analysis..."
    dataset_origin = copy.deepcopy(dataset)
    dataset_origin = np.array(dataset_origin)
    data = [[] for i in range(0,len(dataset[0]))]
    for label in dataset:
        data = [data[i]+label[i] for i in range(0, len(data))]
    data = np.array(data)
    # compute mean and variance
    mean_PCA = np.mean(data,1)
##    variance = np.var(data,1) 
    # shift data to zero-mean
    for feature in range(0,len(data)):
        data[feature] = data[feature] - mean_PCA[feature]
    # compute covariance matrix
    cov = np.cov(data)
    # compute eigenValues and eigenVectors
    eigenValues, eigenVectors = np.linalg.eigh(cov)
    # sort eigenValues and eigenVectors (sort from low to high)
    idx = np.argsort(eigenValues)
    eigenValues = eigenValues[idx] # sort by row
    eigenVectors = eigenVectors[:,idx] # sort by column
    # transpose the eigenVectors to make it on row
    eigenVectors = eigenVectors.transpose()
    # flip eigenVectors and eigenValues (sort from high to low)
    eigenVectors = np.flipud(eigenVectors)
    eigenValues = np.flipud(eigenValues)
    # choose k principle components (eigenVectors)
    k = 0
    sum_v = sum(eigenValues)
    sum_now = 0
    for v in eigenValues:
        sum_now += v
        k += 1
##        if(float(sum_now)/float(sum_v)>=threshold): break
        if(k==threshold): break
    eigenVectors = eigenVectors[0:k]
    eigenValues = eigenValues[0:k]
    # map data to new axis
    dataset_PCA = []
    for label in dataset_origin:
        # shift data to zero-mean
        for feature in range(0,len(label)):            
            label[feature] = label[feature] - mean_PCA[feature]          
        # map data to new axis
        label_PCA = np.dot(eigenVectors, label)
        dataset_PCA.append(label_PCA)
    print "feature number =",len(dataset_PCA[0])
    print "-----------------------------------------"
    returnData = []
    returnData.append(copy.deepcopy(np.array(dataset_PCA)))
    returnData.append(copy.deepcopy(eigenVectors))
    returnData.append(copy.deepcopy(mean_PCA))
    return returnData

#### plot data
def plot(X,Y):
    #### set graph position (row column graphPosition)
    graph = plt.subplot(111)
    #### set graph scale
    graph.set_xscale('linear')
    #### set formatter
    formatter = EngFormatter(unit='', places=1)
    graph.xaxis.set_major_formatter(formatter)      
##    #### assign value to axis  
##    graph.axis([0, maxX, minY-0.02, 1])
    #### plot data
    graph.plot(X, Y, 'r', label='samples')
##    graph.plot(X, Y[0], 'r', label='samples')
##    graph.plot(X, Y[1], 'g', label='800 samples')
##    graph.plot(X, Y[2], 'b', label='600 samples')
##    graph.plot(X, Y[3], 'c', label='400 samples')
##    graph.plot(X, Y[4], 'm', label='200 samples')
    graph.legend(loc='lower right',fancybox=True)
    #### text on X and Y axis
##    graph.set_title("k-fold cross-validation")
    graph.set_xlabel('principle component analysis')
    graph.set_ylabel('Accuracy')
##    graph.set_xlabel('number of k')
    graph.set_xlabel('number of features')
    #### show graph
    plt.show()
    
# split data
def splitDataset(data, testStart, testEnd):
    # numpy type data
    train = []
    test = []
    label = []
    feature = []    
    # construct data structure
    labelNumber = len(data)
    featureNumber = len(data[0])
    for i in range(0,featureNumber):
        feature.append([])
    for i in range(0,labelNumber):       
        train.append(copy.deepcopy(feature))
        test.append(copy.deepcopy(feature))
    # split data
    for i in range(0,labelNumber):
        for j in range(0,featureNumber): 
            test[i][j] = data[i][j][testStart:testEnd]
            train_f = data[i][j][0:testStart]
            train_b = data[i][j][testEnd:len(data[i][j])]
            if(len(train_f)==0): train[i][j] = train_b
            elif(len(train_b)==0): train[i][j] = train_f
            else: train[i][j] = np.append(train_b, train_f) # numpy type data
    # return data
    return {"train":copy.deepcopy(train),"test":copy.deepcopy(test)}

### normalize data
##def normalize(data):
##    print "normalize data"
##    label = []
##    feature = []
##    data_n = []    
##    # construct data structure
##    labelNumber = len(data)
##    featureNumber = len(data[0])
##    for i in range(0,featureNumber):
##        feature.append({"variance":0,"mean":0})
##    for i in range(0,labelNumber):       
##        data_n.append(copy.deepcopy(feature))
##    # normalize data
##    for i in range(0,labelNumber):
##        for j in range(0,featureNumber):
##            # calculate mean of each feature
##            data_n[i][j]["mean"] = sum(data[i][j])/len(data[i][j])
##            # calculate variance of each feature
##            data_n[i][j]["variance"] = np.var(data[i][j])
##    # return data
##    return copy.deepcopy(data_n)

# normalize data
def normalize(data):
    print "normalize data"
    label = []
    feature = []
    data_n = []    
    # construct data structure
    labelNumber = len(data)
    featureNumber = len(data[0])-1
    for i in range(0,featureNumber):
        feature.append({"variance":0,"mean":0})
    for i in range(0,labelNumber):       
        data_n.append(copy.deepcopy(feature))
    # normalize data
    for i in range(0,labelNumber):
        for j in range(0,featureNumber):
            # calculate mean of each feature
            data_n[i][j]["mean"] = sum(data[i][j])/len(data[i][j])
            # calculate variance of each feature
            data_n[i][j]["variance"] = np.var(data[i][j])
    for i in range(0,labelNumber):
        sequence = {}
        for s in data[i][featureNumber]:
            if(sequence.has_key(s)==False):
                sequence.setdefault(int(s),1)
            else:
                sequence[s] += 1
        data_n[i].append(sequence)
    # return data
    return copy.deepcopy(data_n)

# Gaussian distribution
def pGaussian_log(x, mean, variance):
    if(variance == 0.0): return 0
    else:
        f = np.log(1/np.sqrt(2 * np.pi * variance))
        b = - (x - mean)**2 / (2 * variance)
        return copy.deepcopy(f+b)
    
### Gaussian Naive Bayes classifier
##def GNBclassifier(sample, data_n):
##    labelNumber = len(data_n)
##    trainNumber = len(data_n[0][0])
##    featureNumber = len(data_n[0]) 
##    pXgivenY_log_label = []
##    for number in range(0,labelNumber):
##        pXgivenY_log_label.append(0)
##    # calculate probability
##    for feature in range(0,featureNumber):                
##        # calculate P(Xi|Y)
##        x = sample[feature]
##        for label in range(0,labelNumber):
##            mean = data_n[label][feature]["mean"]
##            variance = data_n[label][feature]["variance"]                     
##            tempP = pGaussian_log(x, mean, variance)
##            pXgivenY_log_label[label] += tempP
##    idx = np.argmax(pXgivenY_log_label)
##    return {"idx":copy.deepcopy(idx), "value":copy.deepcopy(pXgivenY_log_label)}
    
# Gaussian Naive Bayes classifier
def GNBclassifier(sample, data_n):
    labelNumber = len(data_n)
    trainNumber = len(data_n[0][0])
    featureNumber = len(data_n[0])-1
    pXgivenY_log_label = []
    for number in range(0,labelNumber):
        pXgivenY_log_label.append(0)
    # calculate probability of first 36 feature
    for idx_F in range(0,featureNumber):                
        # calculate P(Xi|Y)
        x = sample[idx_F]
        for idx_L in range(0,labelNumber):
            mean = data_n[idx_L][idx_F]["mean"]
            variance = data_n[idx_L][idx_F]["variance"]                     
            tempP_log = pGaussian_log(x, mean, variance)
            pXgivenY_log_label[idx_L] += tempP_log
    # calculate probability of the last feature       
    x = sample[featureNumber]
    beta_prior = cf.config("beta_prior")
    for idx_L in range(0,labelNumber):
        if(data_n[idx_L][featureNumber].has_key(x)==True):
            tempP = float(data_n[idx_L][featureNumber][x])/float(sum(data_n[idx_L][featureNumber].values()))            
            tempP_log = np.log(beta_prior) + np.log(tempP)
        else:
            tempP_log = np.log(beta_prior)
        pXgivenY_log_label[idx_L] += tempP_log       
    idx = np.argmax(pXgivenY_log_label)
    return {"idx":copy.deepcopy(idx), "value":copy.deepcopy(pXgivenY_log_label)}

# k fold cross validation
def kFoldCrossValidation(data, K):
    span = len(data[0][0])/K
    kFoldAccuracy = 0
    labelName = cf.config("labelName")
    for k in range(0,K):
        print k,"th fold validation"
        # usage: data["train"/"test"][label][feature]
        data_split = splitDataset(data, k*span, (k+1)*span)    
        trueCounter = 0
        falseCounter = 0
        labelNumber = len(data)
        train = data_split["train"]
        test = data_split["test"]
        trainNumber = len(train[0][0])
        testNumber = len(test[0][0])
        print "number of training example:", trainNumber
        print "number of testing example:", testNumber
        print "testing example start point:", k*span
        print "testing example end point:", (k+1)*span
        # calculate mean and standard deviation
        train_n = normalize(train)
        # Gaussian Naive Bayes Classifier
        labelNumber = len(test)
        featureNumber = len(test[0])
        for i in range(0,labelNumber):
            print "test label:",labelName[i]
            tempTrue = 0
            tempFalse = 0
            for s in range(0, testNumber):
                sample = []
                for j in range(0,featureNumber):                
                    sample.append(test[i][j][s])
                GNB = GNBclassifier(sample, train_n)
                if(GNB["idx"]==i): tempTrue += 1
                else: tempFalse += 1
            trueCounter += tempTrue
            falseCounter += tempFalse
            tempAccuracy = float(tempTrue)/float(tempTrue+tempFalse)
            print "     accuracy =",tempAccuracy
            print "     true counter =",tempTrue
            print "     false counter =",tempFalse
        # calculate accuracy
        accuracy = float(trueCounter)/float(trueCounter+falseCounter)
        kFoldAccuracy += accuracy
        print k,"th fold accuracy: ", accuracy
        print "-----------------------------------------"
    return copy.deepcopy(kFoldAccuracy/K)

# estimate true accuracy      
def estimateAccuracy(flag_PCA, threshold_PCA):
    dataset = im.readFile()
    labelName = dataset["labelName"]

    if(flag_PCA == True):
        X = range(1,38)
        Y = []
        for i in X:
            data_PCA, eigenVectors, mean_PCA = PCA(copy.deepcopy(dataset["data"]), i)
            accuracy = kFoldCrossValidation(copy.deepcopy(data_PCA), 10)
            Y.append(accuracy)
        plot(X, Y)
    else:
        X = range(2,11)
        Y_num = [cf.config("sampleSize")]
        Y = []
        for num in Y_num:
            data = copy.deepcopy(dataset["data"])
            for i in range(0,len(data)):
                for j in range(0,len(data[0])):
                    data[i][j] = data[i][j][0:num]
            temp = []
            for i in range(2,11):
                accuracy = kFoldCrossValidation(data, i)
                temp.append(accuracy)
            Y.append(temp)
        plot(X, Y)
            
if __name__ == "__main__":
    main()

