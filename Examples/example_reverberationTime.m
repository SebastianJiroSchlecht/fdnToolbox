% Example for reverberation time and initial level estimation with
% decayFitNet
%
% Test script with synthetically generated noise to evaluate the
% reverberation time estimation based on the energy decay relief
% (EDR).
%
% Sebastian J. Schlecht, Friday, 23. October 2020
% modified: Friday, 27 January 2023

clear; clc; close all;

fs = 48000;

rirLen = round(3*fs); % samples
RT60 = 2; % seconds
gainPerSample = db2mag(RT602slope(RT60, fs)); 
initialLevel = db2mag(4);
noiseLevel = db2mag(-50);

% Synthesise ideal RIR
rir = initialLevel * randn(rirLen,1) .* gainPerSample .^ (0:rirLen-1)' ...
    + randn(rirLen,1) * noiseLevel;

% Load decayFitNet model and estimate parameters
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs);
fBands = net.preprocessing.filterFrequencies;
[est.T, est.A, est.N, est.norm] = net.estimateParameters(rir);
est.T = est.T'; est.A = est.A'; est.N = est.N'; est.norm = est.norm';
[est.L, est.A, est.N] = decayFitNet2InitialLevel(est.T, est.A, est.N, est.norm, fs, rirLen, fBands);

% Compute EDC
[trueEDCs,~] = rir2decay(rir, fs, fBands, true, true, false); % doBackwardsInt=true, analyseFullRIR=true, normalize=true
edcLen = size(trueEDCs,1);
timeAxis = (0:edcLen-1).'/fs;
estEDCs = generateSyntheticEDCs(est.T', est.A', est.N', timeAxis).';

% Plot
figure; hold on; grid on;
plot(timeAxis,pow2db(trueEDCs));
set(gca,'ColorOrderIndex',1)
plot(timeAxis,pow2db(estEDCs),'--');
xlabel('Time (seconds)');
ylabel('Energy (dB)');

figure; hold on; grid on;
plot(fBands,RT60 * ones(size(fBands)))
plot(fBands,est.T)
legend({'Target','Estimation'})
xlabel('Frequency (Hz)')
ylabel('Reverberation Time (seconds)')
ylim([0 RT60*1.5]);
set(gca, 'XScale', 'log')

figure; hold on; grid on;
plot(fBands, mag2db(initialLevel) * ones(size(fBands)))
plot(fBands, mag2db(est.L) )
legend({'Target','Estimation'})
xlabel('Frequency (Hz)')
ylabel('Initial Amplitude (dB)')
set(gca, 'XScale', 'log')

%% Test: script finnished
assert(1 == 1)