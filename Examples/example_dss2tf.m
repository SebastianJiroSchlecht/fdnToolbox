% Example for dss2tf
%
% Convert delay state-space form of an FDN into the transfer function form
% (dss2tf). Verify the translation by error in the impulse response.
%
% Sebastian J. Schlecht, Sunday, 13. January 2019
clear; clc; close all;

rng(5)
fs = 48000;
impulseResponseLength = fs/4;

% Define FDN
N = 4;
numInput = 3;
numOutput = 2;
B = eye(N,numInput);
C = eye(numOutput,N);
D = randn(numOutput,numInput);
delays = randi([50,100],[1,N]);
A = randomOrthogonal(N);

% ss -> tf -> impz
[tfB,tfA] = dss2tf(delays,A,B,C,D);
irTF = mtf2impz(tfB,tfA,impulseResponseLength);
polesTF = roots(tfA);

% ss -> pr -> impz
[res, pol, direct, isConjugatePolePair] = dss2pr(delays,A,B,C,D);
irPR = pr2impz(res, pol, direct, isConjugatePolePair, impulseResponseLength);
irPR = permute(irPR,[2 3 1]);

allPoles = restoreConjugatePairs(pol, isConjugatePolePair,'poles');
allResidues = restoreConjugatePairs(res, isConjugatePolePair,'residues');

% plot
figure(1); hold on; grid on;
plot(real(allPoles),imag(allPoles),'x');
plot(real(polesTF),imag(polesTF),'o');
legend({'PR Poles','TF Poles'})
xlabel('Real Axis')
ylabel('Imaginary Axis')

figure(2); hold on; grid on;
plot(squeeze(irTF(1,1,:)))
plot(squeeze(irPR(1,1,:)))
legend({'TF','PR'})
xlabel('Time [samples]')
ylabel('Amplitude [lin]')
%axis([1 1 1 1])

%% Test: Impulse Response Accuracy
assert(isAlmostZero(irPR - irTF, 'tol', 10^-10))

%% Test: Pole Estimation Accuracy 
poleError = sort(polesTF(imag(polesTF) >= 0),'ComparisonMethod','real') - sort(allPoles.','ComparisonMethod','real');
assert(isAlmostZero(poleError, 'tol', 10^-10))


