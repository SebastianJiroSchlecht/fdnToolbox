% Example for FDN with allpass filters in the loop
%
% Schroeder allpass filters can be inserted into FDN loop after the delay
% lines to increase the echo density. Allpass FDNs are also still lossless
% and all poles lie on the unit circle.
%
% Sebastian Jiro Schlecht, Sunday, 29 December 2019

clear; clc; close all;

rng(5)
fs = 48000;
impulseResponseLength = fs/4;

% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([200,900],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% Allpass Filter
filterLen = 7;
allpass.a = 0.01*randn(N,1,filterLen);
allpass.a(:,:,1) = 1;
allpass.b = allpass.a(:,:,end:-1:1);
zAllpass = zTF(allpass.b,allpass.a,'isDiagonal',true);

% compute
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct, 'inputType', 'splitInput', 'AbsorptionFilters', zAllpass);
[res, pol, directTerm, isConjugatePolePair,metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'AbsorptionFilters', zAllpass);
resLS = impz2res(irTimeDomain, pol, isConjugatePolePair);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;

% plot
close all;

figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t(1:end), difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'x');
plot(angle(pol),mag2db(abs(resLS)),'o');
xlabel('Pole Angle [rad]')
ylabel('Residue Magnitude [dB]')

figure(3); hold on; grid on;
plot(angle(pol),(mag2db(abs(pol))),'x');
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')

%% Test: Impulse Response Accuracy
assert( isAlmostZero(difference, 'tol', 10^-10))

%% Test: FDN is lossless 
assert( isAlmostZero( abs(pol) - 1) )
