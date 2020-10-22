% Example for dss2pr_direct
% 
% Comparison of methods for modal decomposition of FDNs including proposed
% Ehrlich-Aberth Iteration (EAI), eigenvalue decomposition (eig),
% polynomial eigenvalue decomposition (polyeig), and, polynomial root
% finder (roots). 
%
% Sebastian J. Schlecht, Sunday, 13. January 2019
clear; clc; close all;

rng(8)   
fs = 48000;
impulseResponseLength = fs/4;

% FDN define
N = 4;
numInput = 1;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([50,100],[1,N]);
matrix = randn(N)/2; 
impulseResponseLength = 1000;
% compute
tic
[res.EAI, pol.EAI, directTerm.EAI, isConjugatePolePair.EAI] = dss2pr(delays, matrix, inputGain, outputGain, direct);
ir.EAI = pr2impz(res.EAI, pol.EAI, directTerm.EAI, isConjugatePolePair.EAI, impulseResponseLength);
toc
tic
[res.eig, pol.eig, directTerm.eig, isConjugatePolePair.eig] = dss2pr_direct(delays, matrix, inputGain, outputGain, direct,'eig');
ir.eig = pr2impz(res.eig, pol.eig, directTerm.eig, isConjugatePolePair.eig, impulseResponseLength);
toc
tic
[res.polyeig, pol.polyeig, directTerm.polyeig, isConjugatePolePair.polyeig] = dss2pr_direct(delays, matrix, inputGain, outputGain, direct,'polyeig');
ir.polyeig = pr2impz(res.polyeig, pol.polyeig, directTerm.polyeig, isConjugatePolePair.polyeig, impulseResponseLength);
toc
tic
[res.roots, pol.roots, directTerm.roots, isConjugatePolePair.roots] = dss2pr_direct(delays, matrix, inputGain, outputGain, direct,'roots');
ir.roots = pr2impz(res.roots, pol.roots, directTerm.roots, isConjugatePolePair.roots, impulseResponseLength);
toc

% plot
close all;

figure(1); hold on; grid on;
fnames = fieldnames(pol);
markers = {'x','o','<','>'};
for it = 1:length(fnames)
    name = fnames{it};
    plot(angle(pol.(name)),mag2db(abs(pol.(name))),markers{it});
end
legend(fnames)
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')

figure(2); hold on; grid on;
fnames = fieldnames(pol);
markers = {'x','o','<','>'};
for it = 1:length(fnames)
    name = fnames{it};
    plot(angle(pol.(name)),mag2db(abs(res.(name))),markers{it});
end
legend(fnames)
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')

figure(3); hold on; grid on;
fnames = fieldnames(pol);
markers = {'x','o','<','>'};
for it = 1:length(fnames)
    name = fnames{it};
    plot(ir.(name));
end
legend(fnames)
xlabel('Pole Angle [rad]')
ylabel('Pole Magnitude [dB]')

%% Test: EAI and Eig Poles are equal
assert(isAlmostZero( sort(pol.EAI) - sort(pol.eig), 'tol', 10^-10))

%% Test: EAI and Polyeig Poles are equal
assert(isAlmostZero( sort(pol.EAI) - sort(pol.polyeig), 'tol', 10^-10))

%% Test: EAI and Roots Poles are equal
assert(isAlmostZero( sort(pol.EAI) - sort(pol.roots), 'tol', 10^-10))

%% Test: EAI and Eig Residues are equal
assert(isAlmostZero( sort(res.EAI) - sort(res.eig), 'tol', 10^-10))

%% Test: EAI and Polyeig Residues are equal
assert(isAlmostZero( sort(res.EAI) - sort(res.polyeig), 'tol', 10^-10))

%% Test: EAI and Roots Residues are equal
assert(isAlmostZero( sort(res.EAI) - sort(res.roots), 'tol', 10^-10))
