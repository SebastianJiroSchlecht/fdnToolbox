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
RT60 = 1;
gainPerSample = db2mag(RT602slope(RT60, fs));
initialLevel = db2mag(0);
noiseLevel = db2mag(-90);

rir = initialLevel * randn(irLen,1) .* gainPerSample .^ (0:irLen-1)' + randn(irLen,1) * noiseLevel;


%% Load model and estimate parameters
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs);
F0 = net.preprocessing.filterFrequencies;
[t_est, a_est, n_est, norm_est] = net.estimateParameters(rir);
% denormalize the amplitudes
a_est = a_est .* norm_est;
n_est = n_est .* norm_est;

rirFBands = octaveFiltering(rir, fs, F0);


% EDC
[trueEDCs,~] = rir2decay(rir, fs, F0, true, true, false); % doBackwardsInt=true, analyseFullRIR=true, normalize=true
timeAxis = linspace(0, (size(trueEDCs, 1) - 1) / fs, size(trueEDCs,1) );
estEdc_ = generateSyntheticEDCs(t_est, a_est, n_est, timeAxis).';

figure; hold on; grid on;
plot(pow2db(trueEDCs));
set(gca,'ColorOrderIndex',1)
plot(pow2db(estEdc_),'--');


% estimated level
irFBands = octaveFiltering([1; zeros(fs,1)], fs, F0);
bandEnergy = sum(irFBands.^2,1);


pow2db(a_est.') % !!! this changes strongly when irLen changes. Why?

pow2db((sum(rirFBands.^2 / irLen,1)))
pow2db((bandEnergy))

[decayFBands, normvals] = rir2decay(rir, fs, F0, true, true, false);
pow2db(decayFBands(1,:))


pow2db((sum(rir.^2 / irLen,1))) + db((bandEnergy))

% RT60 is inf
% sum(randn(irLen,1).^2) / irLen % = 1

% RT60 is non-inf
% db(sum(((gainPerSample.^2) .^ (0:irLen-1)')) / irLen )

% geometric series
pow2db((sum(rir.^2 / irLen)))
pow2db( 1 ./ (1 - gainPerSample.^2) / irLen )

%
decayEnergy = 1 ./ (1 - gainPerSample.^2);

estimatedLevel = pow2db(a_est ./ bandEnergy.' * irLen ./ decayEnergy) .'


% plot
figure; hold on; grid on;
plot(F0,RT60 * ones(size(F0)))
plot(F0, t_est)
legend({'Target','Estimation'})
xlabel('Frequency [Hz]')
ylabel('Reverberation Time')
ylim([0 RT60*1.5]);
set(gca, 'XScale', 'log')

figure; hold on; grid on;
plot(F0, mag2db(initialLevel) * ones(size(F0)))
plot(F0, (estimatedLevel) )
xlabel('Frequency [Hz]')
ylabel('Initial Amplitude')
% ylim([0 Inf])
set(gca, 'XScale', 'log')

%% Test: script finnished
assert(1 == 1)