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

import serial
import csv
import numpy as np
import time
import config as cf
import training as tr
import importFile as im
import time

def getData(fileName, mode, flag_PCA, threshold_PCA, threshold_label):
    arduino_port_L = cf.config("arduino_port_L")
    arduino_port_R = cf.config("arduino_port_R")
    buffer_size = cf.config("buffer_size")
    sampleRate = cf.config("sampleRate")
    sampleSize = cf.config("sampleSize")
    idx_LF = cf.config("idx_LF")
    idx_LB = cf.config("idx_LB")
    idx_RF = cf.config("idx_RF")
    idx_RB = cf.config("idx_RB")
    sampleCounterMax = sampleSize + buffer_size*2
    # get data
    buffer_fft_L = []
    buffer_fft_R = []
    counter = 0
    normalize_buffer_fft_L = []
    normalize_buffer_fft_R = []
    sequence_buffer_last = [0,0,0,0] # [LF, LB, RF, RB]
    sequence = [0,0,0,0]
    # initialize buffer for FFT
    buffer_temp = [0]*buffer_size
    for i in range(0,6):
        buffer_fft_L.append(copy.deepcopy(buffer_temp))
        buffer_fft_R.append(copy.deepcopy(buffer_temp))
        normalize_buffer_fft_L.append(copy.deepcopy(buffer_temp))
        normalize_buffer_fft_R.append(copy.deepcopy(buffer_temp))    
    # open serial port that Arduino is using
##    ser_R = serial.Serial(arduino_port_R, 57600, serial.EIGHTBITS,
##                          serial.PARITY_NONE, serial.STOPBITS_ONE,
##                          0, False, False, None, False, None)
##    ser_L = serial.Serial(arduino_port_L, 57600, serial.EIGHTBITS,
##                          serial.PARITY_NONE, serial.STOPBITS_ONE,
##                          0, False, False, None, False, None)
    ser_R = serial.Serial(arduino_port_R, 57600)
    ser_L = serial.Serial(arduino_port_L, 57600)
    # open csv file writer
    if(mode=="g"):
        writer = csv.writer(open("dataset/train/"+fileName+".csv", "ab"))
    if(mode=="t"):
        writer = csv.writer(open("dataset/test/"+fileName+".csv", "ab"))
        # read and normalize training data
        print "Read and normalize training data..."
        dataset = im.readFile()
        if(flag_PCA == True):
            data_PCA, eigenVectors, mean_PCA = tr.PCA(copy.deepcopy(dataset["data"]), threshold_PCA)
            data_n = tr.normalize(copy.deepcopy(data_PCA))
        else:
            eigenVectors = None
            mean_PCA = None
            data_n = tr.normalize(copy.deepcopy(dataset["data"]))
        labelName = dataset["labelName"]
        print "label =", labelName
    # main loop
    while True:
        if(counter == sampleCounterMax): break
        if(ser_L.inWaiting()==0 or ser_R.inWaiting()==0):
            continue
        # get data from arduino
        shoe_R = ser_R.readline().strip().split(",")
        shoe_L = ser_L.readline().strip().split(",")
        # flush data
##        if(ser_L.inWaiting()>200 or ser_R.inWaiting()>200):
##            ser_L.flushInput()
##            ser_R.flushInput()
        ser_L.flushInput()
        ser_R.flushInput()                     
        # check if data are correct
        if(len(shoe_L)!=7 or len(shoe_R)!=7):
            continue # ignore incorrect data
        else:
            if(shoe_L[0]!="L" or shoe_R[0]!="R"):
                continue # ignore incorrect data
            else: # data are correct
                shoe_L.pop(0)
                shoe_R.pop(0)
                try:
                    shoe_L = [int(x) for x in shoe_L]
                    shoe_R = [int(x) for x in shoe_R]
                except: continue
                counter += 1
        # compute sequence
        sequence_buffer_current = [0,0,0,0] # [LF, LB, RF, RB]
        for idx in idx_LF:
            if(shoe_L[idx]>=500):
                sequence_buffer_current[0] = 1
                break
        for idx in idx_LB:
            if(shoe_L[idx]>=500):
                sequence_buffer_current[1] = 1
                break
        for idx in idx_RF:
            if(shoe_R[idx]>=500):
                sequence_buffer_current[2] = 1
                break
        for idx in idx_RB:
            if(shoe_R[idx]>=500):
                sequence_buffer_current[3] = 1
                break
##        print sequence_buffer_last
##        print sequence_buffer_current
##        print "----------------------"
        for i in range(0,len(sequence_buffer_current)):
            if(sequence_buffer_last[i]==0 and sequence_buffer_current[i]==1):
                sequence.pop()
                sequence.insert(0,i+1)
        sequence_buffer_last = sequence_buffer_current
        sequence_num = 0
        for i in range(0,len(sequence)):
            sequence_num += (10**(len(sequence)-i-1))*sequence[i]            
        # prepare to compute FFT
        mean_L = []
        mean_R = []
        freq_L = []
        freq_R = []
        magnitude_L = []
        magnitude_R = []
        # add to buffer
        for i in range(0,6):
            buffer_fft_L[i].pop()
            buffer_fft_R[i].pop()
            buffer_fft_L[i].insert(0,shoe_L[i])
            buffer_fft_R[i].insert(0,shoe_R[i])
            # find mean value
            mean_Li = sum(buffer_fft_L[i])/buffer_size
            mean_L.append(mean_Li)
            mean_Ri = sum(buffer_fft_R[i])/buffer_size
            mean_R.append(mean_Ri)
            # normalize data
            normalize_buffer_fft_L[i] = [x-mean_Li for x in buffer_fft_L[i]]
            normalize_buffer_fft_R[i] = [x-mean_Ri for x in buffer_fft_R[i]]
        # compute FFT
        for item in normalize_buffer_fft_L:
            temp = np.array(item)
            magnitudes = np.fft.fft(temp)
            freqs = np.fft.fftfreq(len(magnitudes))
            idx = np.argmax(np.abs(magnitudes)**2)
            freq = freqs[idx]
            freq_Hz=abs(freq*sampleRate)
            freq_L.append(freq_Hz)
            magnitude_L.append(np.abs(magnitudes[idx]))
        for item in normalize_buffer_fft_R:
            temp = np.array(item)
            magnitudes = np.fft.fft(temp)
            freqs = np.fft.fftfreq(len(magnitudes))
            idx = np.argmax(np.abs(magnitudes)**2)
            freq = freqs[idx]
            freq_Hz=abs(freq*sampleRate)
            freq_R.append(freq_Hz)
            magnitude_R.append(np.abs(magnitudes[idx]))
        # prepare data
        sample = mean_L + magnitude_L + freq_L + mean_R + magnitude_R + freq_R
        sample.append(sequence_num)
        if(counter>=buffer_size*2+1):
            if(mode=="g"):
                # write to csv
                writer.writerow(sample)
                printt = sample[0:6]+sample[18:24]
                printt.append(sample[36])
                print printt
            if(mode=="t"):
                # get and classify data
                if(flag_PCA == True):
                    sample_PCA = np.array(sample)
                    sample_PCA = sample_PCA - mean_PCA
                    sample_PCA = np.dot(eigenVectors, np.transpose(sample_PCA))
                    GNB = tr.GNBclassifier(copy.deepcopy(sample_PCA), copy.deepcopy(data_n))
                else:
                    GNB = tr.GNBclassifier(copy.deepcopy(sample), copy.deepcopy(data_n))
                value = GNB["value"]
                idx = GNB["idx"]
                label = labelName[int(idx)]
                # write to csv
                if(value[idx]>=threshold_label):
                    writer.writerow(sample)
                    print label, [int(v) for v in value]
##                    similar = [v for v in value if np.abs(v-value[idx])<50]
##                    if(len(similar)==1): print label, [int(v) for v in value]
        else: print "buffering...",counter
            
