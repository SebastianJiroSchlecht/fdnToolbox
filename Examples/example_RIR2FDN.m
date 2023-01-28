% Example for converting a room impulse response into an FDN
%
% This example uses DecayFitNet to estimate the energy decay parameters and
% designs graphic equalizers to match the decay
%
% Impulse response is from Promenadikeskus concert hall in Pori, Finland
% published in http://legacy.spa.aalto.fi/projects/poririrs/
% 
% (c) Sebastian Jiro Schlecht: 2023-01-28
clear; clc; close all;

% parameters
rng(5)
fs = 48000;
fBands = [1 63, 125, 250, 500, 1000, 2000, 4000, 8000 fs]; % Hz
cInd = 2:numel(fBands)-1; % center band indices

% load RIR
rir = audioread('s3_r4_o.wav');
rir = rir(:,1);
[~,onset] = max(abs(rir));
rir = rir(onset:end,:);
rir = rir ./ norm(rir);
rirLen = size(rir,1);

% approximate RIR with a single slope
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs, fBands(cInd));
[est.T, est.A, est.N, est.norm] = net.estimateParameters(rir);
est = transposeAllFields(est);
[est.L, est.A, est.N] = decayFitNet2InitialLevel(est.T, est.A, est.N, est.norm, fs, rirLen, fBands(cInd) );

% define FDN
N = 16;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,3500],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% absorption filters, shorten top and bottom band
T60frequency = [1, fBands fs];
targetT60 = est.T([1 1:end end]);  % seconds
targetT60 = targetT60 .* [0.9 1 1 1 1 1 1 1 0.9 0.5];

zAbsorption = zSOS(absorptionGEQ(targetT60, delays, fs),'isDiagonal',true);

% initial level filter, attenuate top and bottom band
targetLevel = mag2db(est.L([1 1:end end]));  % dB
targetLevel = targetLevel - [5 0 0 0 0 0 0 0 5 30];

equalizationSOS = designGEQ(targetLevel);
outputFilters = zSOS(permute(equalizationSOS,[3 4 1 2]) .* outputGain);

% compute impulse response
irFDN = dss2impz(rirLen, delays, feedbackMatrix, inputGain, outputFilters, direct, 'absorptionFilters', zAbsorption);
irFDN = irFDN ./ norm(irFDN);

% estimate FDN reverberation time
[fdn.T, fdn.A, fdn.N, fdn.norm] = net.estimateParameters(irFDN);
fdn = transposeAllFields(fdn);
[fdn.L, fdn.A, fdn.N] = decayFitNet2InitialLevel(fdn.T, fdn.A, fdn.N, fdn.norm, fs, rirLen, fBands(cInd) );

% adjust global gain from initial level estimation
fdn.L = fdn.L ./ geomean(fdn.L) .* geomean(est.L);


% plot
figure;
spectrogram(rir,2^12,2^12-2^8,2^12,fs,'yaxis')
set(gca,YScale='log');
title('Target RIR')

figure;
spectrogram(irFDN,2^12,2^12-2^8,2^12,fs,'yaxis')
set(gca,YScale='log');
title('FDN Impulse Response')

figure; hold on; grid on;
plot(fBands(cInd),est.T);
plot(fBands(cInd),fdn.T);
set(gca,'XScale','log');
xlabel('Frequency (Hz)')
ylabel('Reverberation Time (s)')
legend({'Target RIR','FDN'})
xlim([50 fs/2]);
ylim([0 Inf])

figure; hold on; grid on;
plot(fBands(cInd),mag2db(est.L));
plot(fBands(cInd),mag2db(fdn.L));
set(gca,'XScale','log');
xlabel('Frequency (Hz)')
ylabel('Initial Level (dB)')
legend({'Target RIR','FDN'})
xlim([50 fs/2]);


%% Test: TODO
% add EDC accuracy

%% Test: Reverberation Time Accuracy, 20% threshold
assert(all(abs(est.T ./ fdn.T - 1) < 0.2))

