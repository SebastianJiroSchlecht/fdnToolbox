% Example for absorption graphic equalizer (GEQ) in FDN
%
% TODO: This example is not finished yet. 
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(5)

fs = 48000;
impulseResponseLength = fs*2;

% define FDN
N = 3;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% absorption filters
centerFrequencies = [ 63, 125, 250, 500, 1000, 2000, 4000, 8000]; % Hz
T60frequency = [1, centerFrequencies fs];
targetT60 = [2; 2; 2.5; 2.3; 2.1; 1.5; 1.1; 0.8; 0.7; 0.7];  % seconds
absorptionFilters = filterVector(absorptionGEQ(targetT60, delays, fs));

              
              
% power correction filter
targetPower = [0; 0; -2.5; -3; -4; -5; -11; -13; -15; -18];  % dB
powerCorrectionFilters = dfilt.df2sos(designGEQ(targetPower));


% compute impulse response and apply power correction
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', absorptionFilters);
% irTimeDomain = powerCorrectionFilters.filter(irTimeDomain);

%% compute poles/zeros
% TODO fix absorption filters
[res, pol, directTerm, isConjugatePolePair,metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', absorptionFilters);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;
fprintf('Maximum devation betwen time-domain and pole-residues is %f\n', permute(max(abs(difference),[],1),[2 3 1]));
% 
[reverberationTimeEarly, reverberationTimeLate, F0, powerSpectrum, edr] = reverberationTime(irTimeDomain, fs);

%% plot
figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

 
figure(2); hold on; grid on;
plot(T60frequency,targetT60(:,1));
plot(F0,reverberationTimeLate);
plot(F0,reverberationTimeEarly);
% plot(rad2hertz(angle(pol),fs),slope2RT60(mag2db(abs(pol)), fs),'x');
set(gca,'XScale','log');
xlim([50 fs/2]);
xlabel('Frequency [Hz]')
ylabel('Reverberation Time [s]')
legend({'Target Curve','T60 Late','T60 Early','Poles'})

figure(3); hold on; grid on;
plot(T60frequency, targetPower);
plot(F0,powerSpectrum);
set(gca,'XScale','log');
xlim([50 fs/2]);
legend({'Estimation'})
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')




%% Test: TODO: not written yet
% add T60 tolerance test
assert(1 == 1)


