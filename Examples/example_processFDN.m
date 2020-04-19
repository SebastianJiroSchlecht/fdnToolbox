% Example for processFDN
% Apply reverberation to signal
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

[x, fs] = audioread('synth_dry.m4a');
x = [x; zeros(2*fs,1)];

%% Define FDN
N = 8;
numInput = 1;
numOutput = 2;
inputGain = ones(N,numInput);
outputGain = rand(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([500,2000],[1,N]);
numberOfStages = 2;
sparsity = 3;
maxShift = 30;
[feedbackMatrix, revFeedbackMatrix] = constructVelvetFeedbackMatrix(N,numberOfStages,sparsity);
[feedbackMatrix, revFeedbackMatrix] = randomMatrixShift(maxShift, feedbackMatrix, revFeedbackMatrix );

%% absorption filters including delay of scattering matrix
[approximation,approximationError] = matrixDelayApproximation(feedbackMatrix);

RT_DC = 2; % seconds
RT_NY = 0.5; % seconds

[absorption.b,absorption.a] = onePoleAbsorption(RT_DC, RT_NY, delays + approximation, fs);
loopMatrix = zDomainAbsorptionMatrix(feedbackMatrix, absorption.b, absorption.a);

%% compute impulse response and poles/zeros and reverberation time
output = processFDN(x, delays, loopMatrix, inputGain, outputGain, direct);

%% sound
% soundsc(x,fs);
soundsc(output,fs);