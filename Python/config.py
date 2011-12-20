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

def config(s):
    if(s=="sampleRate"): return 30
    elif(s=="buffer_size"): return 90
    elif(s=="sampleSize"): return 210000
    elif(s=="arduino_port_L"): return "COM5"
    elif(s=="arduino_port_R"): return "COM14"
    elif(s=="featureNumber"): return 37
    elif(s=="idx_LF"): return [4,5] # left front shoe sensors group
    elif(s=="idx_LB"): return [2,1] # left back shoe sensors group
    elif(s=="idx_RF"): return [0,5] # right front shoe sensors group
    elif(s=="idx_RB"): return [2,1] # right back shoe sensors group
    elif(s=="default_threshold_PCA"): return 15
    elif(s=="default_threshold_label"): return -300
    elif(s=="beta_prior"): return 1e-1
    elif(s=="labelName"):
        return {0:"sit",1:"stand",
                2:"walkFront",3:"walkBack",4:"walkRight",5:"walkLeft",
                6:"turnRight",7:"turnLeft",
                8:"upstair",9:"downstair"}

    
