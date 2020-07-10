% Example for nestedAllpass and seriesAllpass
%
% FDNs can be allpass. There are two designs based on series and nested
% combination of Schroeder allpass filters.
%
% see Sebastian J. Schlecht, Allpass Feedback Delay Networks, submitted to
% IEEE TSP, 2020
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
clear; clc; close all;

N = 3;
delays = [3 5 11];
g = [0.3 0.6 0.11];

%% Test: Nested Allpass
[matrix, inputGain, outputGain, direct] = nestedAllpass(g)
[num,den] = dss2tf(delays,matrix,inputGain,outputGain,direct)
[numSym,denSym] = dss2tfSym(delays,matrix,inputGain,outputGain,direct)

isA = isUniallpass(matrix, inputGain, outputGain, direct)
assert( isA )

%% Test: Symbolic Nested Allpass
sym_g = sym('g',[1,N]);
[matrix, inputGain, outputGain, direct] = nestedAllpass(sym_g)

assert(1 == 1) % there is no simple test

%% Test: Series Allpass
[matrix, inputGain, outputGain, direct] = seriesAllpass(g)

isA = isUniallpass(matrix, inputGain, outputGain, direct)
assert( isA )



