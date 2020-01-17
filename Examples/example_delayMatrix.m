% Example for Delay Matrix FDN and plotting the pole quality
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
clear; clc; close all;

rng(7)
fs = 48000;
impulseResponseLength = fs;

%% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = 0*randn(numOutput,numInput);
delays = ( randi([50,100],[1,N]) ); 
H = hadamard(N)/sqrt(N)/2;

degree = 20;
delayIndices = randi(degree,[N N])

feedbackMatrixDelay = constructDelayFeedbackMatrix(delayIndices,H);
loopMatrix = zDomainLoop(zDomainDelay(delays), zDomainMatrix(feedbackMatrixDelay));

%% compute
irTimeDomain = ss2impz_fdn(impulseResponseLength, delays, feedbackMatrixDelay, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair, metaData] = ss2pr_fdn(delays, feedbackMatrixDelay, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference),[],1),[2 3 1])

%% compute zplane quality
Abs = linspace(0.9, 1.02, 100);
Frequency = linspace(-pi, pi, 1000);
[x,y] = ndgrid(Frequency, Abs);
quality = poleQuality(y.*exp(1i*x), loopMatrix);

%% plot
close all;

figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
surf(x,mag2db(y),zeros(size(x))-1,clip(1./quality,[1 100]),'EdgeColor','none');
shading interp
view([0 90])

[allPoles] = restoreConjugatePairs(pol, isConjugatePolePair,'poles');
plot(angle(allPoles),mag2db(abs(allPoles)),'rx');
plot(angle(metaData.recordPoles),mag2db(abs(metaData.recordPoles)),'-o');

xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')
legend({'Pole Quality','Poles','Pole Refinement'})
xlim([-pi,pi]);
ylim(mag2db([min(Abs) max(Abs)]));
