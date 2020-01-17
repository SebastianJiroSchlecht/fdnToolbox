% Example for absorption filters in FDN
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(5)

fs = 48000;
impulseResponseLength = fs*2;

%% define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
feedbackMatrix = randomOrthogonal(N);

%% absorption filters
filterOrder = 32;

T60frequency = [0; 500; 5000; 8000; fs/2];

targetT60 = [2;1.5;0.5]*ones(1,N);  % seconds; copy for each channel
targetT60 = [targetT60(1,:); targetT60; targetT60(end,:)];

absorption = absorptionFilters(T60frequency, targetT60, filterOrder, delays, fs);
absorptionMatrix = polydiag( absorption );

absorptionFeedbackMatrix = matrixConvolution(feedbackMatrix, absorptionMatrix);

%% compute impulse response and poles/zeros
irTimeDomain = ss2impz_fdn(impulseResponseLength, delays, absorptionFeedbackMatrix, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair,metaData] = ss2pr_fdn(delays, absorptionFeedbackMatrix, inputGain, outputGain, direct);
irResPol = pr2impz_fdn(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;
fprintf('Maximum devation betwen time-domain and pole-residues is %f\n', permute(max(abs(difference),[],1),[2 3 1]));

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
plot(rad2hertz(angle(pol),fs),slope2RT60(mag2db(abs(pol)), fs),'x');
plot(F0,reverberationTimeLate);
plot(F0,reverberationTimeEarly);
set(gca,'XScale','log');
xlim([50 fs/2]);
xlabel('Frequency [hz]')
ylabel('Pole RT60 [s]')
legend({'Target Curve','Poles','Minimum','Maximum','T60 Late','T60 Early'})


