% Example for absorption graphic equalizer (GEQ) in FDN
%
% This example demonstrates the use of a 10 band GEQ for both the recursive
% absorption and the initial level.
%
% (c) Sebastian Jiro Schlecht:  22. October 2020
% modified Saturday, 28 January 2023
clear; clc; close all;

% parameters
rng(5)
fs = 48000;
rirLen = 2*fs; % samples
fBands = [1 63, 125, 250, 500, 1000, 2000, 4000, 8000 fs]; % Hz
cInd = 2:numel(fBands)-1; % center band indices

% define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% absorption filters
targetT60 = [2, 2, 2.2, 2.3, 2.1, 1.5, 1.1, 0.8, 0.7, 0.7];  % seconds
zAbsorption = zSOS(absorptionGEQ(targetT60, delays, fs),'isDiagonal',true);

% initial level filters
targetLevel = [5, 5, 5, 3, 2, 1, -1, -3, -5, -5];  % dB
equalizationSOS = designGEQ(targetLevel);
outputFilters = zSOS(permute(equalizationSOS,[3 4 1 2]) .* outputGain);

% compute impulse response
rir = dss2impz(rirLen, delays, feedbackMatrix, inputGain, outputFilters, direct, 'absorptionFilters', zAbsorption);
rir = rir ./ norm(rir);

% compute FDN poles
[res, pol, directTerm, isConjugatePolePair,metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputFilters, direct, 'absorptionFilters', zAbsorption);

% estimate reverberation times 
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs, fBands(cInd));
[est.T, est.A, est.N, est.norm] = net.estimateParameters(rir);
est.T = est.T'; est.A = est.A'; est.N = est.N'; est.norm = est.norm';
[est.L, est.A, est.N] = decayFitNet2InitialLevel(est.T, est.A, est.N, est.norm, fs, rirLen, fBands(cInd) );

% adjust global gain from initial level estimation
est.L = est.L ./ geomean(est.L) .* geomean(db2mag(targetLevel));

% compute EDC
[trueEDCs,~] = rir2decay(rir, fs, fBands(cInd), true, true, false); % doBackwardsInt=true, analyseFullRIR=true, normalize=true
edcLen = size(trueEDCs,1);
timeAxis = (0:edcLen-1).'/fs;
estEDCs = generateSyntheticEDCs(est.T', est.A', est.N', timeAxis).';


%% plot
figure; hold on; grid on;
plot(timeAxis,pow2db(trueEDCs));
set(gca,'ColorOrderIndex',1)
plot(timeAxis,pow2db(estEDCs),'--');
xlabel('Time (seconds)');
ylabel('Energy (dB)');
 
figure; hold on; grid on;
plot(fBands,targetT60);
plot(fBands(cInd),est.T);
plot(rad2hertz(angle(pol),fs),slope2RT60(mag2db(abs(pol)), fs),'.');
set(gca,'XScale','log');
xlim([50 fs/2]);
ylim([0 Inf])
xlabel('Frequency (Hz)')
ylabel('Reverberation Time (s)')
legend({'Target Curve','T60 Late','Poles'})

figure; hold on; grid on;
plot(fBands, targetLevel);
plot(fBands(cInd), mag2db(est.L));
set(gca,'XScale','log');
xlim([50 fs/2]);
legend({'Target','Estimation'})
xlabel('Frequency (Hz)')
ylabel('Initial Level (dB)')

%% Test: Reverberation Time Accuracy, 10% threshold
testF0 = linspace(65,8000,20);
testTarget = interp1(fBands,targetT60, testF0);
testEsti = interp1(fBands(cInd), est.T, testF0);
assert(all(abs(testEsti ./ testTarget - 1) < 0.1))

%% Test: Initial Level Accuracy, 1dB threshold 
testF0 = linspace(65,8000,20);
testTarget = interp1(fBands,targetLevel, testF0);
testEsti = interp1(fBands(cInd), mag2db(est.L), testF0);
assert(all(abs(testEsti - testTarget) < 1))

