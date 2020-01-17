% Example for ss2tf_fdn
%
% Sebastian J. Schlecht, Sunday, 13. January 2019
clear; clc; close all;

rng(5)
fs = 48000;
impulseResponseLength = fs/4;

%% Define FDN
N = 4;
numInput = 3;
numOutput = 2;
B = eye(N,numInput);
C = eye(numOutput,N);
D = randn(numOutput,numInput);
delays = randi([50,100],[1,N]);
A = randomOrthogonal(N);

%% ss -> tf -> impz
[tfB,tfA] = dss2tf(delays,A,B,C,D);
irTF = mtf2impz(tfB,tfA,impulseResponseLength);
polesTF = roots(tfA);

%% ss -> pr -> impz
[res, pol, direct, isConjugatePolePair] = ss2pr_fdn(delays,A,B,C,D);
irPR = pr2impz(res, pol, direct, isConjugatePolePair, impulseResponseLength);
irPR = permute(irPR,[2 3 1]);

allPoles = restoreConjugatePairs(pol, isConjugatePolePair,'poles');
allResidues = restoreConjugatePairs(res, isConjugatePolePair,'residues');

%% compare
maximumDeviation = max( abs(irPR - irTF), [], 3)

%% plot
figure(1); hold on; grid on;
plot(real(allPoles),imag(allPoles),'x');
plot(real(polesTF),imag(polesTF),'o');
legend({'PR Poles','TF Poles'})
xlabel('Real Axis')
ylabel('Imaginary Axis')

 
