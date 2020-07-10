% Example for FDN with spread modal decay
%
% Demonstrate FDN not with a homogenous decay but with a certain spread
% which is also typically observed in shoebox rooms and scattering delay
% networks. THe spread is evaluated via the modal decomposition.
%
% see Schlecht, S., Habets, E. (2019). Modal Decomposition of Feedback
% Delay Networks IEEE Transactions on Signal Processing  67(20), 5340-5351.
% https://dx.doi.org/10.1109/tsp.2019.2937286
%
% (c) Sebastian Jiro Schlecht:  23. April 2018
clear; clc; close all;

rng(1)
fs = 48000;
impulseResponseLength = 2*fs;
types = {'Proportional', 'Spread'};

% Define FDN
N = 8;
numInput = 1;
numOutput = 1;
inputGain = eye(N,numInput);
outputGain = eye(numOutput,N);
direct = randn(numOutput,numInput);
delays = randi([500,2000],[1,N]);

gainPerSample = 0.9999;
GainMatrix =  diag( gainPerSample.^delays );
feedbackMatrix.Proportional = randomOrthogonal(N) * GainMatrix;
feedbackMatrix.Spread = randomOrthogonal(N) * GainMatrix * randomOrthogonal(N);

% Modal decomposition / Impulse Response / Energy Decay Curve
for it = 1:length(types)
    type = types{it};
    [res.(type), pol.(type), directTerm.(type), isConjugatePolePair.(type)] = dss2pr(delays, feedbackMatrix.(type), inputGain, outputGain, direct);
    irResPol.(type) = pr2impz(res.(type), pol.(type), directTerm.(type), isConjugatePolePair.(type), impulseResponseLength, 'lowMemory'); 
    edc.(type) = EDC(irResPol.(type));
end


% plot
close all;

figure(1); hold on; grid on;
t = smp2ms(1:impulseResponseLength,fs)/ 1000;
for it = 1:length(types)
    type = types{it};
    plot(t,edc.(type));
end
legend(types)
xlabel('Time [seconds]')
ylabel('Energy Decay Curve [dB]')


figure(2); hold on; grid on;
for it = 1:length(types)
    type = types{it};
    plot(angle(pol.(type)),slope2RT60(mag2db(abs(pol.(type))),fs),'.');
end
legend(types)
xlabel('Pole Angle [rad]')
ylabel('Pole T60 [seconds]')

%% Test: Script finished
assert(1 == 1)
