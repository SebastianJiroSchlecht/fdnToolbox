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

rng(5)

fs = 48000;

centerFrequencies = [ 63, 125, 250, 500, 1000, 2000, 4000, 8000]; % Hz

% analyze RIR

rir = audioread('s3_r4_o.wav');
rir = rir(:,1);
rir = rir ./ norm(rir);
impulseResponseLength = size(rir,1);

nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs, centerFrequencies);
[t_est, a_est, n_est, norm_est] = net.estimateParameters(rir);

[level, a_est, n_est] = decayFitNet2InitialLevel(t_est, a_est, n_est, norm_est, fs, impulseResponseLength, centerFrequencies);

% define FDN
N = 16;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% absorption filters
T60frequency = [1, centerFrequencies fs];
targetT60 = [t_est(1)*0.9 t_est.' t_est(end)/3];  % seconds, shorten top band

zAbsorption = zSOS(absorptionGEQ(targetT60, delays, fs),'isDiagonal',true);

% initial level filter
targetLevel = [level(1)-10 level level(end)-30];  % dB, attenuate top band

equalizationSOS = designGEQ(targetLevel);
outputFilters = zSOS(permute(equalizationSOS,[3 4 1 2]) .* outputGain);

% compute impulse response
irFDN = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputFilters, direct, 'absorptionFilters', zAbsorption);
irFDN = irFDN ./ norm(irFDN);

% estimate FDN reverberation time
[t_fdn, a_fdn, n_fdn, norm_fdn] = net.estimateParameters(irFDN);

%% plot

figure;
spectrogram(rir,2^12,2^12-2^8,2^12,fs,'yaxis')
set(gca,YScale='log');

figure;
spectrogram(irFDN,2^12,2^12-2^8,2^12,fs,'yaxis')
set(gca,YScale='log');

figure; hold on; grid on;
plot(centerFrequencies,t_est);
plot(centerFrequencies,t_fdn);
set(gca,'XScale','log');
xlim([50 fs/2]);
ylim([0 Inf])
xlabel('Frequency [Hz]')
ylabel('Reverberation Time [s]')
legend({'Room Impulse Resonse','FDN'})

%% TODO
% add EDC accuracy

%% Test: Reverberation Time Accuracy, 20% threshold
assert(all(abs(t_est ./ t_fdn - 1) < 0.2))

