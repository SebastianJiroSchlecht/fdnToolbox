% Example of delay proportional absorption (broadband)
%
% (c) Sebastian Jiro Schlecht:  Saturday, 12. January 2019
clear; clc; close all;

rng(3)
fs = 48000;
impulseResponseLength = fs/2;

%% FDN definition
N = 4;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = randn(numOutput,numInput);
delays = randi([50,2000],[1,N]);

gainPerSample = 0.9999;
absorption = (gainPerSample.^delays).';

% scalar version
feedbackMatrix = randomOrthogonal(N) * diag(absorption);

% filter matrix version
feedbackMatrix = constructCascadedParaunitaryMatrix( N, 2, 'gainPerSample', gainPerSample );
feedbackMatrix = matrixConvolution(feedbackMatrix,polydiag(absorption));

%% compute
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct);

[res, pol, directTerm, isConjugatePolePair, metaData] = ss2pr_fdn(delays, feedbackMatrix, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference),[],1),[2 3 1])

%% plot
figure(1); hold on; grid on;
t = 1:size(difference,1);
plot( t(1:end), difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')

figure(2); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'x');
xlabel('Pole Angle [rad]')
ylabel('Residue Magnitude [dB]')

figure(3); hold on; grid on;
plot(angle(pol),slope2RT60(mag2db(abs(pol)), fs),'x');
xlabel('Pole Angle [rad]')
ylabel('Pole RT60 [s]')


