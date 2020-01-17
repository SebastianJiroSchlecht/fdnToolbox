% Example for FFDN with paraunitary feedback matrix 
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(2)
fs = 48000;
impulseResponseLength = 3*fs/1;

%% Define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = 0*randn(numOutput,numInput);
delays = ( randi([1250,6500],[1,N]) ); 

% Paraunitary Feedback Matrix
K = 3; 
[feedbackMatrix, revMatrix] = constructCascadedParaunitaryMatrix( N, K);
isP = isParaunitary( feedbackMatrix )


%% Compute impulse response and poles/zeros
irTimeDomain = ss2impz_fdn(impulseResponseLength, delays, feedbackMatrix, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair, metaData] = ss2pr_fdn(delays, feedbackMatrix, inputGain, outputGain, direct, 'inverseMatrix', revMatrix);
irResPol = pr2impz_fdn(res, pol, directTerm, isConjugatePolePair, impulseResponseLength, 'lowMemory');

%% Evaluate IR Difference between time-domain recursion and poles/zeros
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
plotImpulseResponseMatrix(1:size(feedbackMatrix,3),feedbackMatrix);
legend({'this'})
xlabel(' ')
ylabel(' ')

%% sound
% soundsc(irTimeDomain,fs)



