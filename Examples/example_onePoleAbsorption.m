% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;
filename = mfilename;

rng(1)
fs = 48000;
impulseResponseLength = fs;

%% FDN definition
N = 4;
numInput = 1;
numOutput = 1;inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = ones(numOutput,numInput);
delays = randi([5, 30]*100,[1,N]);
feedbackMatrix = randomOrthogonal(N);

%% Generate absorption filters
RT_DC = 2; % seconds
RT_NY = 0.5; % seconds

[absorption.b,absorption.a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs);
loopMatrix = zDomainAbsorptionMatrix(feedbackMatrix, absorption.b, absorption.a);

%% compute
% with absorption
irTimeDomain = ss2impz_fdn(impulseResponseLength, delays, loopMatrix, inputGain, outputGain, direct, 'inputType', 'splitInput');
tic
[res, pol, directTerm, isConjugatePolePair, metaData] = ss2pr_fdn(delays, loopMatrix, inputGain, outputGain, direct, 'DeflationType', 'neighborDeflation');
toc
irResPol = pr2impz_fdn(res, pol, directTerm, isConjugatePolePair, impulseResponseLength,'lowMemory');

difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference(1:end)),[],1),[2 3 1])

% no absorption
[no_res, no_pol, no_directTerm, no_isConjugatePolePair] = ss2pr_fdn(delays, feedbackMatrix, inputGain, outputGain, direct, 'DeflationType', 'neighborDeflation');
no_irResPol = pr2impz_fdn(no_res, no_pol, no_directTerm, no_isConjugatePolePair, impulseResponseLength,'lowMemory');

%% min max bounds
[MinCurve,MaxCurve,w] = poleBoundaries(delays, absorption, feedbackMatrix);

%% plot
figure(1); hold on; grid on;
t = 1:size(difference,1);
plot( t, difference );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'.','MarkerSize',1);
plot(angle(no_pol),mag2db(abs(no_res)),'.','MarkerSize',1);
legend({'Residues with attenuation','Residues without attenuation'},'Location','southeast')
xlabel('Pole Angular Frequency [rad]')
ylabel('Residue Magnitude [dB]')
set(gca,'XLim',[0 pi],'YLim',[-120 -70]);

figure(4); hold on; grid on;
plotAxes = plot(angle(pol),slope2RT60(mag2db(abs(pol)), fs),'.','MarkerSize',1);
plot(w,slope2RT60(mag2db(MinCurve),fs));
plot(w,slope2RT60(mag2db(MaxCurve),fs)); 
xlabel('Pole Angular Frequency [rad]')
ylabel('Pole RT60 [s]')
set(gca,'YLim',[0 2.2],'XLim',[0 pi]);
legend({'Poles with attenuation','Minimum Bound','Maximum Bound'},'Location','northeast')
