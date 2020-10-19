function [optimalSOS, targetF] = designGEQ ( targetG )
% Graphic EQ with 10 bands
%
% targetG is the target magnitude response in dB of size [10,1]; 
%
% TODO: add documentation
%
% All About Audio Equalization: Solutions and Frontiers
% by V. Välimäki and J. Reiss, 
% in Applied Sciences, vol. 6, no. 5, p. 129, May 2016.
%
% Sebastian J. Schlecht, Monday, 19. October 2020

% Initialization
% Setup variables such as sampling frequency, center frequencies and
% control frequencies, and command gains
fs = 48000;
fftLen = 2^16;

centerFrequencies = [ 63, 125, 250, 500, 1000, 2000, 4000, 8000]; % Hz
ShelvingCrossover = [46 11360]; % Hz
numFreq = length(centerFrequencies) + length(ShelvingCrossover);
shelvingOmega = hertz2rad(ShelvingCrossover, fs);
centerOmega = hertz2rad(centerFrequencies, fs);
R = 2.7;

% control frequencies are spaced logarithmically
numControl = 100;
controlFrequencies = round(logspace(log10(1), log10(fs/2.1),numControl+1));

% target magnitude response via command gains
targetF = [1, centerFrequencies fs];
% targetG = [1; -1; 1; -1; 1; -1; 1; -1; 1; 1]*10; % dB
targetInterp = interp1(targetF, targetG, controlFrequencies)';

% desgin prototype of the biquad sections
prototypeGain = 10; % dB
prototypeGainArray = prototypeGain * ones(numFreq+1,1);
prototypeSOS = graphicEQ(centerOmega, shelvingOmega, R, prototypeGainArray);
[G,prototypeH,prototypeW] = probeSOS (prototypeSOS, controlFrequencies, fftLen, fs);
G = G / prototypeGain; % dB vs control frequencies

% compute optimal parametric EQ gains
% Either you can use a unconstrained linear solver or introduce gain bounds
% at [-20dB,+20dB] with acceptable deviation from the self-similarity
% property. The plot shows the deviation between design curve and actual
% curve.
upperBound = [Inf, 2 * prototypeGain * ones(1,numFreq)];
lowerBound = -upperBound;

optG = lsqlin(G, targetInterp, [],[],[],[], lowerBound, upperBound);
% optG = G\targetInterp; % unconstrained solution
optimalSOS = graphicEQ( centerOmega, shelvingOmega, R, optG );