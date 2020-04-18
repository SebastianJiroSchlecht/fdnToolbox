% Sebastian J. Schlecht, Thursday, 16. April 2020
clear; clc; close all;

rng(5)

fs = 48000;
impulseResponseLength = fs*2;

%% define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
m = randi([100,1000],[1,N])
A = randomOrthogonal(N);
% A = losslessMatrixGallery(N,'Hadamard');

syms z;
delays = diag( z.^m );
adjSym = adjoint(delays - A);

adjMat = msym2poly(adjSym);

%%

plotImpulseResponseMatrix([],adjMat)
