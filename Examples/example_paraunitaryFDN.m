% Example for FFDN with paraunitary feedback matrix 
%
% Large scale example of for a filter feedback delay network (FFDN) with a
% paraunitary scattering matrix. Shows impulse response and modal
% decomposition.
%
% see Schlecht, S., Habets, E. (2020). Scattering in Feedback Delay
% Networks IEEE/ACM Transactions on Audio, Speech, and Language Processing
% https://dx.doi.org/10.1109/taslp.2020.3001395
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(2)
fs = 48000;
impulseResponseLength = 3*fs/1;

% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = 0*randn(numOutput,numInput);
delays = ( randi([1250,6500],[1,N]) ); 

% Paraunitary Feedback Matrix
K = 3; 
[feedbackMatrix, feedbackInverse] = constructCascadedParaunitaryMatrix( N, K);
zFeedbackMatrix = zFIR(feedbackMatrix);

% Compute impulse response and poles/zeros
irTimeDomain = dss2impz(impulseResponseLength, delays, zFeedbackMatrix, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, zFeedbackMatrix, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength, 'lowMemory');

% Evaluate IR Difference between time-domain recursion and poles/zeros
difference = irTimeDomain - irResPol;


% plot
close all;

figure(1); hold on; grid on;
t = 1:size(difference,1);
plot( t, difference(1:end) );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol')


figure(2); hold on; grid on;
plot(angle(pol),mag2db(abs(pol)),'.');
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')
legend({'Poles'})


figure(3); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'.');
xlabel('Pole Angle [rad]')
ylabel('Residue Magnitude [dB]')
legend({'Residues'})

figure(4); hold on; grid on;
plotImpulseResponseMatrix(1:size(feedbackMatrix,3),feedbackMatrix,'xlabel','Time (samples)','ylabel','Amplitude (lin)');

% sound
% soundsc(irTimeDomain,fs)

%% Test: Feedback Matrix is Paraunitary
isP = isParaunitary( feedbackMatrix )
assert( isP ) 

%% Test: Impulse Response Accuracy
matMax = permute(max(abs(difference),[],1),[2 3 1])
assert( isAlmostZero(difference, 'tol', 10^-3 ));

%% Test: Is lossless
assert( isAlmostZero( abs(pol) - 1)  )
