% Example of frequency-dependent pole boundaries
%
% FDN with frequency-dependent absorption filters, but not with
% homogeneous decay (= delay proportional). Still, the pole boundaries can
% be computed and tested.
%
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback
% Delay Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;
rng(6)

fs = 48000;
impulseResponseLength = fs/8;

% Define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = randn(numOutput,numInput);
delays = randi([50,1000],[1,N]);

feedbackMatrix = randomOrthogonal(N)/1.5;

absorption.a = zeros(N,1,2);
absorption.a(:,1,1) = 1;
absorption.b = zeros(N,1,2);
absorption.b(:,1,1) = 0.65;
absorption.b(:,1,2) = 0.3;
zAbsorption = zTF(absorption.b,absorption.a,'isDiagonal',true);

% compute
[MinCurve,MaxCurve,w] = poleBoundaries(delays, absorption, feedbackMatrix);
[res, pol, directTerm, isConjugatePolePair] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', zAbsorption);

% plot
figure(1); hold on; grid on;
plotAxes = plot(angle(pol),slope2RT60(mag2db(abs(pol)), fs),'.');
plot(w,slope2RT60(mag2db(MinCurve),fs),'LineWidth',3);
plot(w,slope2RT60(mag2db(MaxCurve),fs),'LineWidth',3);

legend({'Poles','Minimum Boundary', 'Maximum Boundary'});
xlabel('Pole Angle [rad]')
ylabel('Pole RT60 [s]')

%% Test: Poles between bounds 
[isBounded, isSmaller] = isBoundingCurve(angle(pol),abs(pol),w,MaxCurve,'upper');
assert(isBounded)

[isBounded, isSmaller] = isBoundingCurve(angle(pol),abs(pol),w,MinCurve,'lower');
assert(isBounded)



