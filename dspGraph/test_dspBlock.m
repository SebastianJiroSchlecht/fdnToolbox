% test dspBlock
clear; clc; close all;


signalLength = 4000;
blockSize = 30;
numberOfChannels = 3;

x = randn(signalLength,numberOfChannels);
x = x*0;
x(1,1) = 1;

delays = 30+[5 7 8];
gainPerSample = 0.99;

A = dspMatrix(orth(randn(numberOfChannels)));

Z = dspParallelDelay(delays);
G = dspParallelGains(gainPerSample .^ delays);

ZG = dspSequential(Z,G);

F = dspRecursive(blockSize,ZG,A);

% time-domain processing
blockStart = 0;
y = zeros(signalLength,numberOfChannels);
while (blockStart < signalLength - blockSize)
    blockIndex = blockStart + (1:blockSize);
    block = x(blockIndex,:);
    
    y(blockIndex,:) = F.process(block);

    blockStart = blockStart + blockSize;
end

% z-domain processing
w = circspace(signalLength).';
z = exp(1i .* w);

X = zeros(numel(w),numberOfChannels);
X(:,1) = 1;

Fz = F.at(X,z,'z^-1');

fz = real(ifft(Fz));

%% plot
figure; hold on;
plot(y)

set(gca,'ColorOrderIndex',1)
% figure;
plot(fz - 0*y + 1);
legend('Time-domain processing','Frequency domain sampling')

figure;
plot(fz - y);