% test dspBlock poles
clear; clc; close all;


signalLength = 1000;
blockSize = 30;
numberOfChannels = 2;

delays = 30+[5 11];
gainPerSample = 0.98;

A = dspMatrix(orth(randn(numberOfChannels)));
% A = dspMatrix(hadamard(2)/sqrt(2));

Z = dspParallelDelay(delays);
G = dspParallelGains(gainPerSample .^ delays);

ZG = dspSequential(Z,G);

F = dspRecursive(blockSize,ZG,A);

B = dspMatrix(ones(numberOfChannels,1));
B = dspMatrix([1; 1]);
C = dspMatrix(1+ones(1,numberOfChannels));
D = dspMatrix(1);

FDN = dspSequential(dspSequential(B,F),C);

% z-domain processing
numberOfDelays = sum(delays + 0*blockSize);

[residues, poles, direct, isConjugatePolePair, metaData] = dss2pr_dsp(F,B,C,D);
response = pr2impz(residues, poles, 0, isConjugatePolePair, signalLength);

% z-domain processing
w = circspace(signalLength).';
z = exp(1i .* w);

X = zeros(numel(w),1);
X(:,1) = 1;

FDNz = FDN.at(X,z,'z^-1');

fdnz = real(ifft(FDNz));

%% plot
figure; hold on;
plot(angle(poles),abs(poles),'x');

figure; hold on;
plot(angle(poles),abs(residues),'x');

figure; hold on;
plot(fdnz)
plot(response+1)
legend('Frequency sampling','Pole-residue')