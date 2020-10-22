% Example for added density with a delay feedback matrix
%
% Comparison of FDN echo density with a standard (scalar) feedback matrix
% and a delay feedback matrix.
%
% see Schlecht, S., Habets, E. (2019). Dense Reverberation with Delay Feedback
% Matrices Proc. IEEE Workshop Applicat. Signal Process. Audio Acoust.
% (WASPAA)
%
% Sebastian J. Schlecht, Thursday, 9. April 2020
clear; clc; close all;

rng(7)
fs = 48000;
impulseResponseLength = 0.8*fs;

% Define FDN
N = 16;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = ( randi([3000,8000],[1,N]) ); 
feedbackMatrix.Scalar = hadamard(N)/sqrt(N); randomOrthogonal(N);

degree = 50;
delayIndices = randi(degree,[N 1]) + randi(degree,[1 N]);
feedbackMatrix.Delay = zFIR(constructDelayFeedbackMatrix(delayIndices,feedbackMatrix.Scalar));


% compute
types = {'Scalar', 'Delay'};
for it = 1:numel(types)
    type = types{it};
    irTimeDomain.(type) = dss2impz(impulseResponseLength, delays, feedbackMatrix.(type), inputGain, outputGain, direct);
    [t_abel.(type),echo_dens.(type)] = echoDensity(irTimeDomain.(type), 1024, fs, 0); 
end

% plot
figure(1); hold on; grid on;
t = smp2ms(1:impulseResponseLength,fs);
for it = 1:numel(types)
    type = types{it};
    plot( t, irTimeDomain.(type) - it*2);
end
for it = 1:numel(types)
    type = types{it};
    plot( t, echo_dens.(type) - it*2);
end
legend(types)

%% Test: Increased Echo Density
sumScalar = sum(echo_dens.Scalar,'omitnan');
sumDelay = sum(echo_dens.Delay,'omitnan');
assert( sumDelay > sumScalar);
