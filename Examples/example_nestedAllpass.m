% Example for nestedAllpass
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
clear; clc; close all;

N = 3;
delays = [3 5 11];
g = [0.3 0.6 0.11];

%% Nested Allpass
[matrix, inputGain, outputGain, direct] = nestedAllpass(g)
[num,den] = dss2tf(delays,matrix,inputGain,outputGain,direct)
[numSym,denSym] = dss2tfSym(delays,matrix,inputGain,outputGain,direct)

isA = isAllpassFDN(matrix, inputGain, outputGain, direct)

%% Series Allpass
[matrix, inputGain, outputGain, direct] = seriesAllpass(g)

isA = isAllpassFDN(matrix, inputGain, outputGain, direct)

%% Symbolic Nested Allpass
g = sym('g',[1,N]);
[matrix, inputGain, outputGain, direct] = nestedAllpass(g)


