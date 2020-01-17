% Example for FDN with allpass filters in the loop
%
% Sebastian Jiro Schlecht, Sunday, 29 December 2019

clear; clc; close all;

rng(5)
fs = 48000;
impulseResponseLength = fs/4;

%% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([200,900],[1,N]);

feedbackMatrix = randomOrthogonal(N);

%% Allpass Filter
filterLen = 7;
a = 0.01*randn(N,filterLen);
a(:,1) = 1;
b = a(:,end:-1:1);
absorption.b = b;
absorption.a = a;

loopMatrix = zDomainAbsorptionMatrix(feedbackMatrix, absorption.b, absorption.a);

%% compute
irTimeDomain = dss2impz(impulseResponseLength, delays, loopMatrix, inputGain, outputGain, direct, 'inputType', 'splitInput');
[res, pol, directTerm, isConjugatePolePair,metaData] = ss2pr_fdn(delays, loopMatrix, inputGain, outputGain, direct);
resLS = impz2res(irTimeDomain, pol, isConjugatePolePair);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference),[],1),[2 3 1])
%% plot
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


