% Example for ss2pr_fdn and impz2res_fdn
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
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
delays = randi([50,100],[1,N]);
feedbackMatrix = randomOrthogonal(N);

%% Absorption filters
filterLen = 5;
absorption.a = zeros(N,5);
absorption.a(:,1) = 1;
absorption.b = absorption.a;

loopMatrix = zDomainAbsorptionMatrix(feedbackMatrix, absorption.b, absorption.a);

%% compute
irTimeDomain = ss2impz_fdn(impulseResponseLength, delays, loopMatrix, inputGain, outputGain, direct, 'inputType', 'splitInput');
[res, pol, directTerm, isConjugatePolePair, metaData] = ss2pr_fdn(delays, loopMatrix, inputGain, outputGain, direct);
irResPol = pr2impz_fdn(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);
[res_IR,b0,b1] = impz2res_fdn(irTimeDomain, pol, isConjugatePolePair);

difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference),[],1),[2 3 1])

%% plot
close all;

figure(1); hold on; grid on;
t = 1:size(difference,1);
plot( t, difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'x');
plot(angle(pol),mag2db(abs(res_IR)),'o');
legend('Residues from Pole/Zeros','Residues from Pole/IR');
xlabel('Pole Angle [rad]')
ylabel('Residue Magnitude [dB]')



