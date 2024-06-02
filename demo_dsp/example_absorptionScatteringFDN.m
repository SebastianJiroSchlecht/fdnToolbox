% Example for absorption in Scattering FDNs
%
% Example of a full FDN with absorption (one-pole filter) and scattering
% feedback matrix to create a complex, frequency-dependent reverberation
% tail.
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(1)

fs = 48000;
impulseResponseLength = fs*2;

% define FDN
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
numberOfStages = 3;
sparsity = 3;
maxShift = 30;
[feedbackMatrix, revFeedbackMatrix] = constructVelvetFeedbackMatrix(N,numberOfStages,sparsity);
[feedbackMatrix, revFeedbackMatrix] = randomMatrixShift(maxShift, feedbackMatrix, revFeedbackMatrix );

% absorption filters including delay of scattering matrix
[approximation,approximationError] = matrixDelayApproximation(feedbackMatrix);

RT_DC = 2; % seconds
RT_NY = 0.5; % seconds

crossover_frequency = 1000;
[absorption.b,absorption.a] = firstOrderAbsorption(RT_DC, RT_NY, crossover_frequency, delays, fs);
        
% dsp based
A = dspMatrixFilters(feedbackMatrix);
B = dspMatrix(inputGain);
C = dspMatrix(outputGain);
D = dspMatrix(direct);
Z = dspParallelDelay(delays);
G = dspParallelFilters(absorption.b,absorption.a);

% connect dsp
blockSize = 10000; % TODO: not used
F = dspRecursive(blockSize,dspSequential(Z,G),A); 
FDN = dspSequential(dspSequential(B,F),C);

irTimeDomain = dsp2impz(impulseResponseLength,FDN,'frequency');

% evaluation
% reverberation time analysis - approximate RIR with a single slope
T60frequency = [46, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 11360]'; % Hz
fBands = T60frequency(2:end-1); % center bands
nSlopes = 1;
net = DecayFitNetToolbox(nSlopes, fs, fBands);
estimatedT60 = net.estimateParameters(irTimeDomain);


%% plot
figure(1); hold on; grid on;
t = 1:size(irTimeDomain,1);
plot( t, irTimeDomain );
legend('TimeDomain')


figure(2); hold on; grid on;
% plot(rad2hertz(angle(pol),fs),slope2RT60(mag2db(abs(pol)), fs),'x');
plot(fBands,estimatedT60,'LineWidth',2);
set(gca,'XScale','log');
xlim([50 fs/2]);
ylim([0 Inf]);
xlabel('Frequency [hz]')
ylabel('Pole RT60 [s]')
legend({'Estimated T60 Late'})

figure(3); hold on; grid on;
plotImpulseResponseMatrix(1:size(feedbackMatrix,3),feedbackMatrix,'xlabel','Time (samples)','ylabel','Amplitude (lin)');


%% Test: Scattering Matrix is Lossless
assert( isParaunitary(feedbackMatrix) )




