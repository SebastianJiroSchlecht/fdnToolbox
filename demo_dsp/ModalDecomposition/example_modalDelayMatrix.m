% Example for Delay Matrix FDN and plotting the pole quality
%
% Delay feedback matrices with arbirtary delays are not lossless.
% Nonetheless, here we show a modal decomposition for these FDNs. Further,
% we demontrate the modal decomposition iterations and the pole-quality
% plane for the optimization.
%
% Schlecht, S., Habets, E. (2019). Dense Reverberation with Delay Feedback
% Matrices Proc. IEEE Workshop Applicat. Signal Process. Audio Acoust.
% (WASPAA)
% 
% Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback Delay
% Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
clear; clc; close all;

rng(7)
fs = 48000;
impulseResponseLength = fs;

% Define FDN
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

feedbackMatrixDelay = zFIR(constructDelayFeedbackMatrix(delayIndices,H));
absorptionMatrix = zScalar(diag(eye(numel(delays))),'isDiagonal',true);
loopMatrix = zFDNloop(zDelay(delays.'), absorptionMatrix, feedbackMatrixDelay);

% compute
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrixDelay, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, feedbackMatrixDelay, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;

% compute zplane quality
Abs = linspace(0.9, 1.02, 100);
Frequency = linspace(-pi, pi, 1000);
[x,y] = ndgrid(Frequency, Abs);
quality = poleQuality(y.*exp(1i*x), loopMatrix);

% plot
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

%% Test: Impulse Response Accuracy
assert(isAlmostZero(difference,'tol',10^-10))
