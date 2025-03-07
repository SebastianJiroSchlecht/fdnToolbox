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
impulseResponseLength = fs/4;

% FDN definition
N = 6;
numInput = 1; N;
numOutput = 1; N;
inputGain = randn(N,numInput);
outputGain = randn(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([150,400],[1,N]); 

% Delay feedback matrix
extraDelayIn = randi([1,70],[N,1]); 
extraDelayOut = randi([1,70],[1,N]);

totalDelay = delays + extraDelayIn.' + extraDelayOut;

gainPerSample = 1; 0.9995;
feedbackMatrix = randomOrthogonal(N) * diag(gainPerSample.^totalDelay);

% dsp
% delay feedback matrix
A = dspSequential( dspSequential( dspParallelDelay(extraDelayOut), dspMatrixFilters(feedbackMatrix)), dspParallelDelay(extraDelayIn));
B = dspSequential( dspMatrix(inputGain), dspParallelDelay(extraDelayIn));
C = dspSequential( dspParallelDelay(extraDelayOut), dspMatrix(outputGain));
D = dspMatrix(direct);
Z = dspParallelDelay(delays);

% connect dsp
blockSize = 10000; % TODO: not used
F = dspRecursive(blockSize,Z,A); 
FDN = dspSequential(dspSequential(B,F),C);

irTimeDomain_withDelayMatrix = dsp2impz(impulseResponseLength,FDN,'frequency');

% same total delay lengths but not disentangled
A = dspMatrixFilters(feedbackMatrix);
B = dspMatrix(inputGain);
C = dspMatrix(outputGain);
D = dspMatrix(direct);
Z = dspParallelDelay(totalDelay);

% connect dsp
blockSize = 10000; % TODO: not used
F = dspRecursive(blockSize,Z,A); 
FDN2 = dspSequential(dspSequential(B,F),C);

irTimeDomain_standardMatrix = dsp2impz(impulseResponseLength,FDN2,'frequency');

% plot
figure; hold on; grid on;
t = 1:size(irTimeDomain_withDelayMatrix,1);
plot( t, irTimeDomain_withDelayMatrix,'.' );
plot( t, irTimeDomain_standardMatrix-0.01,'.');
legend('with delay matrix', 'with standard matrix ');
xlabel('Time (samples)')
ylabel('Sample value')
xlim([0 2000]);

figure; hold on; grid on;
t = 1:size(irTimeDomain_withDelayMatrix,1);
plot( t, mag2db(irTimeDomain_withDelayMatrix),'.' );
plot( t, mag2db(irTimeDomain_standardMatrix)-200,'.');
legend('with delay matrix', 'with standard matrix (with 200 dB offset)');
xlabel('Time (samples)')
ylabel('Magnitude (dB)')
xlim([0 2000]);

% 
% %% Test: Impulse Response Equal
% assert(isAlmostZero(difference,'tol',eps*10^5));
% 
% %% Test: Poles are equal
% assert(isAlmostZero(pol - pol2));
% 
% %% Test: Residue magnitudes are equal
% assert(isAlmostZero(abs(res) - abs(res2)));
% isAlmostZero(angle(res) - angle(res2)); % but not phases


