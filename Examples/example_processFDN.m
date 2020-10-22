% Example for processFDN
%
% Apply FDN reverberation to a musical signal
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

[x, fs] = audioread('synth_dry.m4a');
x = [x(:,1); zeros(2*fs,1)];

% Define FDN
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

% absorption filters including delay of scattering matrix
[approximation,approximationError] = matrixDelayApproximation(feedbackMatrix);

RT_DC = 2; % secondss
RT_NY = 0.5; % seconds

[absorption.b,absorption.a] = onePoleAbsorption(RT_DC, RT_NY, delays + approximation, fs);
zAbsorption = zTF(absorption.b, absorption.a,'isDiagonal', true); 

% compute impulse response and poles/zeros and reverberation time
output = processFDN(x, delays, feedbackMatrix, inputGain, outputGain, direct, 'absorptionFilters', zAbsorption);

% soundsc(x,fs);
% soundsc(output,fs);

%% Test: script finished
assert(1 == 1);
