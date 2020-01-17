% Example of frequency-dependent pole boundaries
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;
rng(6)

fs = 48000;
impulseResponseLength = fs/8;

%% Define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = randn(numOutput,numInput);
delays = randi([50,1000],[1,N]);

feedbackMatrix = randomOrthogonal(N)/1.5;

absorption.a = zeros(N,2);
absorption.a(:,1) = 1;
absorption.b = zeros(N,2);
absorption.b(:,1) = 0.65;
absorption.b(:,2) = 0.3;

loopMatrix = zDomainAbsorptionMatrix(feedbackMatrix, absorption.b, absorption.a);

%% compute
[MinCurve,MaxCurve,w] = poleBoundaries(delays, absorption, feedbackMatrix);
[res, pol, directTerm, isConjugatePolePair] = ss2pr_fdn(delays, loopMatrix, inputGain, outputGain, direct);

%% plot
figure(1); hold on; grid on;
plotAxes = plot(angle(pol),slope2RT60(mag2db(abs(pol)), fs),'.');
plot(w,slope2RT60(mag2db(MinCurve),fs),'LineWidth',3);
plot(w,slope2RT60(mag2db(MaxCurve),fs),'LineWidth',3);

legend({'Poles','Minimum Boundary', 'Maximum Boundary'});
xlabel('Pole Angle [rad]')
ylabel('Pole RT60 [s]')
