% Example for dss2pr and impz2res
%
% Small example for modal decomposition (dss2pr) of an FDN and an
% alternative method to determine the residues by least-squares (impz2res).
%
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback Delay
% Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
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
delays = randi([50,100],[1,N]);
feedbackMatrix = randomOrthogonal(N);

% Absorption filters
filterLen = 5;
absorption.a = zeros(N,1,5);
absorption.a(:,1,1) = 1;
absorption.b = absorption.a;
zAbsorption = zTF(absorption.b,absorption.a,'isDiagonal',true);

% compute
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct, 'inputType', 'splitInput', 'AbsorptionFilters', zAbsorption);
[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'AbsorptionFilters', zAbsorption);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);
[res_IR,b0,b1] = impz2res(irTimeDomain, pol, isConjugatePolePair);

difference = irTimeDomain - irResPol;

% plot
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

%% Test: Impulse Response Accuracy
assert(isAlmostZero(difference, 'tol', 10^-10));

%% Test: Residues by Least-Squares
assert(isAlmostZero(res - res_IR, 'tol', 10^-10));





