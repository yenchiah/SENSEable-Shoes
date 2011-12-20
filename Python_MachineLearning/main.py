import copy
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

import numpy as np
import importFile as im
import serial
import config as cf
import csv
import getData as gd
import training as tr
  
# main function  
def main():
    default_threshold_PCA = cf.config("default_threshold_PCA")
    default_threshold_label = cf.config("default_threshold_label")
    print "---------------------------------------------------------------------"
    mode = raw_input("Mode? 'e'=estimateAccuracy, 't'=testing, 'g'=getData -> ")
    print "---------------------------------------------------------------------"
    # estimateAccuracy mode
    if(mode=="e"):
        flag_PCA = raw_input("Principle Component Analysis? 'y'=yes, [press enter]=no -> ")
        if(flag_PCA=="y"):
            threshold_PCA = raw_input("PCA feature number (1 to 37)?  [press enter]=default -> ")
            if(threshold_PCA==""): threshold_PCA = default_threshold_PCA
            tr.estimateAccuracy(True, float(threshold_PCA))
        else:
            tr.estimateAccuracy(False, 1.1)
    # getData mode
    elif(mode=="g"):        
        fileName = raw_input("File name for saving data? -> ")
        gd.getData(fileName, mode, False, 1.1, 0)        
    # test mode
    elif(mode=="t"):
        flag_PCA = raw_input("Principle Component Analysis? 'y'=yes, [press enter]=no -> ")
        if(flag_PCA=="y"):
            threshold_PCA = raw_input("PCA feature number (1 to 37)?  [press enter]=default -> ")
            if(threshold_PCA==""): threshold_PCA = default_threshold_PCA
            threshold_label = raw_input("Label value threshold for prediction? [press enter]=default -> ")
            if(threshold_label==""): threshold_label=default_threshold_label
            fileName = raw_input("File name for saving data? -> ")
            gd.getData(fileName, mode, True, float(threshold_PCA), long(threshold_label))
        else:
            threshold_label = raw_input("Label value threshold for prediction? [press enter]=default -> ")
            if(threshold_label==""): threshold_label=default_threshold_label
            fileName = raw_input("File name for saving data? -> ")
            gd.getData(fileName, mode, False, 1.1, long(threshold_label))   
    # wrong mode
    else: print "wrong mode... program terminated"
                  
if __name__ == "__main__":
    main()

