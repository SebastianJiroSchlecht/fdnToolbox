% test dspBlock
clear; clc; close all;

fs = 48000;
signalLength = 40000;
blockSize = 30;
numberOfChannels = 3;

x = randn(signalLength,numberOfChannels);
x = x*0;
x(1,1) = 1;

delays = 30+[5 7 8];

% gainPerSample = 0.99;
% G = dspParallelGains(gainPerSample .^ delays);

% Generate absorption filters
RT_DC = 0.4; % seconds
RT_NY = 0.1; % seconds
crossover_frequency = 2000; % Hz
[absorption.b,absorption.a] = firstOrderAbsorption(RT_DC, RT_NY, crossover_frequency, delays, fs);

G = dspParallelFilters(absorption.b,absorption.a);
A = dspMatrix(orth(randn(numberOfChannels)));
Z = dspParallelDelay(delays);
Ff = dspRecursive(blockSize,dspSequential(Z,G),A);

% 
Zt = dspParallelDelay(delays-blockSize);
Ft = dspRecursive(blockSize,dspSequential(Zt,G),A);

% time-domain processing
yt = dsp2impz(signalLength, Ft, 'time');

% z-domain processing
yf = dsp2impz(signalLength, Ff, 'frequency');

%% plot
figure; hold on;
plot(yt)
set(gca,'ColorOrderIndex',1)
plot(yf + 1);
legend('Time-domain processing','Frequency domain sampling')

figure;
plot(yf - yt);