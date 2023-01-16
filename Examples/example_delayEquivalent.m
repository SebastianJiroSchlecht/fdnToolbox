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
% modified: Monday, 16 January 2023
clear; clc; close all;

rng(1)

fs = 48000;
impulseResponseLength = fs/64;

% FDN definition
N = 3;
numInput = N;
numOutput = N;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([50,100],[1,N]); 

% Delay feedback matrix
extraDelayIn = [1 4 3]'; % test equivalence between delay in matrix and extra delay in delays
extraDelayOut = [5 2 4];

matrixDelays = 1 + extraDelayIn + extraDelayOut;

feedbackMatrix = randomOrthogonal(N);
feedbackMatrixDelay = zFIR(constructDelayFeedbackMatrix(matrixDelays,feedbackMatrix));

% compute with delay matrix
irTimeDomain = dss2impz(impulseResponseLength, delays, feedbackMatrixDelay, inputGain, outputGain, direct);
[res, pol, directTerm, isConjugatePolePair, metaData] = dss2pr(delays, feedbackMatrixDelay, inputGain, outputGain, direct);
irResPol = pr2impz(res, pol, directTerm, isConjugatePolePair, impulseResponseLength);

% compare time-domain recursion with pole residue response
irTimeDomain = sum(irTimeDomain,[2 3]);
irResPol = sum(irResPol,[2 3]);
difference = irTimeDomain - irResPol;
matMax = permute(max(abs(difference),[],1),[2 3 1])

% compute delay equivalent FDN
extendedDelays = delays+extraDelayIn'+extraDelayOut;
irTimeDomain2 = dss2impz(impulseResponseLength + max(matrixDelays(:)), extendedDelays, feedbackMatrix, inputGain, outputGain, direct);
[res2, pol2, directTerm2, isConjugatePolePair2, metaData2] = dss2pr(extendedDelays, feedbackMatrix, inputGain, outputGain, direct);

% shift input and outputs by the extra delays
irTimeDomain2 = mcircshift(irTimeDomain2,-matrixDelays.'+1);
irTimeDomain2 = sum(irTimeDomain2,[2 3]);
irTimeDomain2 = irTimeDomain2(1:impulseResponseLength,:,:); % shorten the response to the same lengts

% plot
figure; hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, difference );
plot( t, irTimeDomain - 2 );
plot( t, irResPol - 4 );
legend('Difference', 'TimeDomain', 'Res Pol');

figure; hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, irTimeDomain - irTimeDomain2);
plot( t, irTimeDomain - 2 );
plot( t, irTimeDomain2 - 4 );
legend('Difference', 'TimeDomain', 'TimeDomain Equivalent');

figure; hold on; grid on;
plot(angle(pol),0*mag2db(abs(pol)),'x');
plot(angle(pol2),0*mag2db(abs(pol2)),'o');
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')
legend({'Delay Matrix Poles','Equivalent Delay Poles'})

figure; hold on; grid on;
plot(angle(pol),mag2db(abs(res(:,1,1))),'x');
plot(angle(pol2),mag2db(abs(res2(:,1,1))),'o');
xlabel('Pole Angle [rad]')
ylabel('Residue Magnitude [dB]')
legend({'Delay Matrix Residues','Equivalent Delay Residues'})

%% Test: Impulse Response Equal
assert(isAlmostZero(difference,'tol',eps*10^5));

%% Test: Poles are equal
assert(isAlmostZero(pol - pol2));

%% Test: Residue magnitudes are equal
assert(isAlmostZero(abs(res) - abs(res2)));
isAlmostZero(angle(res) - angle(res2)); % but not phases


