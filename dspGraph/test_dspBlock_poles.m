% test dspBlock poles
clear; clc; close all;

fs = 48000;
signalLength = 80000;
blockSize = 30;
numberOfChannels = 3;

delays = 30+[5 11 17];

% gainPerSample = 0.98;
% G = dspParallelGains(gainPerSample .^ delays);

% Generate absorption filters
% RT_DC = 0.2; % seconds
% RT_NY = 0.1; % seconds
% crossover_frequency = 2000; % Hz
% [absorption.b,absorption.a] = firstOrderAbsorption(RT_DC, RT_NY, crossover_frequency, delays, fs);
% G = dspParallelFilters(absorption.b,absorption.a);

% absorption filters
filterOrder = 8; 64;
T60frequency = [0, 63, 125, 250, 500, 1000, 2000, 4000, 8000, fs/2]'; % Hz
targetT60 = [2 linspace(2,0.5,8) 0.5]'.^0.3;
absorption = absorptionFilters(T60frequency, targetT60*ones(1,numberOfChannels), filterOrder, delays, fs);
G = dspParallelFilters(permute(absorption,[1 3 2]));


A = dspMatrix(orth(randn(numberOfChannels)));
feedbackMatrix = [0 1 0; 0 0 1; 1 0 0];
A = dspMatrix(feedbackMatrix);
% A = dspMatrix(hadamard(2)/sqrt(2));

Z = dspParallelDelay(delays);

ZG = dspSequential(Z,G);

% F = dspRecursive(blockSize,ZG,A);
F = dspRecursive(blockSize,Z,dspSequential(G,A));

B = dspMatrix(ones(numberOfChannels,1));
% B = dspMatrix([1; 0; 0]);
C = dspMatrix(1+ones(1,numberOfChannels));
D = dspMatrix(0);

FDN = dspSequential(dspSequential(B,F),C);

% pole-residue processing
[residues, poles, direct, isConjugatePolePair, metaData] = dss2pr_dsp(F,B,C,D);
response = pr2impz(residues, poles, 0, isConjugatePolePair, signalLength);

% z-domain processing
fdnz = dsp2impz(signalLength, FDN, 'frequency');

%% plot
figure; hold on;
plot(angle(poles),abs(poles),'x');

figure; hold on;
plot(angle(poles),abs(residues),'x');

figure; hold on;
plot(fdnz)
plot(response+1)
legend('Frequency sampling','Pole-residue')

figure; hold on;
plot(fdnz - response)