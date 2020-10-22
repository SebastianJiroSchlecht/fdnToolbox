% Example of delay proportional absorption (broadband)
%
% Delay-proportional absorption combined with a lossless feedback matrix
% yields a homogeneous decay of all modes. This is tested with the modal
% decomposition of a filter feedback matrix.
%
% see Schlecht, S., Habets, E. (2020). Scattering in Feedback Delay
% Networks IEEE/ACM Transactions on Audio, Speech, and Language Processing
% https://dx.doi.org/10.1109/taslp.2020.3001395
%
% (c) Sebastian Jiro Schlecht:  Saturday, 12. January 2019
clear; clc; close all;

rng(3)
fs = 48000;
impulseResponseLength = fs/2;

% FDN definition
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
feedbackMatrix = zFIR(matrixConvolution(feedbackMatrix,polydiag(absorption)));

% compute
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct);

[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, feedbackMatrix, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;


% plot
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

%% Test: Impulse Response Validation
matMax = permute(max(abs(difference),[],1),[2 3 1])
assert( isAlmostZero(difference, 'tol', 10^-3)  ) 

%% Test: Homogenous Decay
assert( isAlmostZero(abs(pol) - gainPerSample) ); 


