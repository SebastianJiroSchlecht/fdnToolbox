% Example for time-varying matrices
%
% Process a musical sound with a time-varying FDN reverberation. Different
% options include slow and fast time-variation.
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
clear; clc; close all;

rng(1);

% init source signal
switch 'sine'
    case 'sine'
        fs = 48000;
        time = linspace(0,4,4*fs)';
        synth1 = 0.5 * sin( time * 440 * 2*pi ) ;
        synth2 = 0.5 * sin( time * 660 * 2*pi ) ;
        synth = [synth1, synth2];
    case 'melody'
        [synth, fs] = audioread('synth_dry.m4a');
        time = smp2ms(1:length(synth),fs)*1000;
end

% Define FDN
N = 8;
numInput = 2;
numOutput = 2;
inputGain = orth(randn(N,numInput));
outputGain = orth(randn(numOutput,N)')';
direct = zeros(numOutput,numInput);
delays = randi([750,2000],[1,N]);
feedbackMatrix = randomOrthogonal(N);

%% Generate absorption filters
RT_DC = 4; % seconds
RT_NY = 1; % seconds

[absorption.b,absorption.a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs);
zAbsorption = zTF(absorption.b, absorption.a,'isDiagonal', true); 


% Process sound for all matrix types
matrixTypes = {'FastVariation','SlowVariation','NoVariation'};
for it = 1:length(matrixTypes)
    type = matrixTypes{it};
    switch type
        case 'NoVariation'
            modulationFrequency = 0; % hz
            modulationAmplitude = 0.0;
            spread = 0;
        case 'SlowVariation'
            modulationFrequency = 1; % hz
            modulationAmplitude = 0.9;
            spread = 0.3;
        case 'FastVariation'
            modulationFrequency = 10; % hz
            modulationAmplitude = 0.1;
            spread = 0.7;
    end
    
    TVmatrix = timeVaryingMatrix(N, modulationFrequency, modulationAmplitude, fs, spread);
    reverbedSynth.(type) = processFDN(synth, delays, feedbackMatrix, inputGain, outputGain, direct, 'inputType', 'mergeInput', 'extraMatrix', TVmatrix, 'absorptionFilters', zAbsorption);    
end

% Plot
figure(1); hold on; grid on;

for it = 1:length(matrixTypes)
    plot(time, reverbedSynth.(matrixTypes{it})(:,1) + it*2);
end
legend(matrixTypes)
xlabel('Time [seconds]')
ylabel('Amplitude')

% sound
% soundsc(reverbedSynth.SlowVariation,fs);

%% Test: Script finished
assert(1 == 1)




