% Delay equivalent for delay feedback matrix
%
% Paraunitary delay matrices are equivalent to longer delay lines and
% delayed inputs and outputs. Essentially, the poles of both systems are
% equivalent and however only the residue magnitude (not phase) is
% identical.
%
% See: Schlecht, S., Habets, E. (2019). Dense Reverberation with Delay
% Feedback Matrices Proc. IEEE Workshop Applicat. Signal Process. Audio
% Acoust. (WASPAA)
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(1)

fs = 48000;
impulseResponseLength = fs/64;

% FDN definition
N = 3;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([50,100],[1,N]); 

% Delay feedback matrix
% degree = 5;
extraDelay = [1 4 3]; % test equivalence between delay in matrix and extra delay in delays

delayIndices = ones(N,1).*[1+extraDelay]

feedbackMatrix = randomOrthogonal(N);
feedbackMatrixDelay = constructDelayFeedbackMatrix(delayIndices,feedbackMatrix);
inverseMatrix = permute(feedbackMatrixDelay,[2 1 3]); % simple transpos because it is paraunitary

matrixFilter = zFIR(feedbackMatrixDelay);

% compute with delay matrix
irTimeDomain = dss2impz(impulseResponseLength, delays, matrixFilter, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, matrixFilter, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference),[],1),[2 3 1])

% compute delay equivalent FDN
[res2, pol2, directTerm2, isConjugatePolePair2, metaData2] = dss2pr(delays+extraDelay, feedbackMatrix, inputGain, outputGain, direct);


% plot
figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, difference(1:end) );
plot( t, irTimeDomain(:,1,1) - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol');

figure(2); hold on; grid on;
plot(angle(pol),0*mag2db(abs(pol)),'x');
plot(angle(pol2),0*mag2db(abs(pol2)),'o');
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')
legend({'Delay Matrix Poles','Equivalent Delay Poles'})

figure(3); hold on; grid on;
plot(angle(pol),mag2db(abs(res)),'x');
plot(angle(pol2),mag2db(abs(res2)),'o');
xlabel('Pole Angle [rad]')
ylabel('Residue Magnitude [dB]')
legend({'Delay Matrix Residues','Equivalent Delay Residues'})

%% Test: Impulse Response Equal
assert(isAlmostZero(difference));

%% Test: Poles are equal
assert(isAlmostZero(pol - pol2));

%% Test: Residue magnitudes are equal
assert(isAlmostZero(abs(res) - abs(res2)));
isAlmostZero(angle(res) - angle(res2)); % but not phases


