% Example for reverberation time and power spectrum estimation.
%
% Test script with synthetically generated noise to evaluate the
% reverberation time estimation method based on the energy decay relief
% (EDR).
%
% Sebastian J. Schlecht, Friday, 23. October 2020
% modified: Friday, 27 January 2023

clear; clc; close all;

fs = 48000;

irLen = round(10*fs);
RT60 = 2;
gainPerSample = db2mag(RT602slope(RT60, fs));
initialLevel = db2mag(0);
noiseLevel = db2mag(-90);

rir = initialLevel * randn(irLen,1) .* gainPerSample .^ (1:irLen)' + randn(irLen,1) * noiseLevel;

db(sqrt(sum(rir.^2)))

%% Load model and estimate parameters
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs);
[t_est, a_est, n_est, norm_est] = net.estimateParameters(rir);
% denormalize the amplitudes
a_est = a_est .* norm_est;
n_est = n_est .* norm_est;

db(a_est) % !!! this changes strongly when irLen changes. Why?

F0 = net.preprocessing.filterFrequencies;

% estimated level
rirFBands = octaveFiltering([1; zeros(fs,1)], fs, F0);
bandEnergy = sum(rirFBands.^2,1).';

estimatedLevel = pow2db(a_est ./ bandEnergy * irLen / (RT60 * fs)); 


% plot
figure(1); hold on; grid on;
plot(F0,RT60 * ones(size(F0)))
plot(F0, t_est)
legend({'Target','Estimation'})
xlabel('Frequency [Hz]')
ylabel('Reverberation Time')
ylim([0 RT60*1.5]);
set(gca, 'XScale', 'log')

figure(2); hold on; grid on;
plot(F0, mag2db(initialLevel) * ones(size(F0)))
plot(F0, (estimatedLevel) )
xlabel('Frequency [Hz]')
ylabel('Initial Amplitude')
% ylim([0 Inf])
set(gca, 'XScale', 'log')

%% Test: script finnished
assert(1 == 1)