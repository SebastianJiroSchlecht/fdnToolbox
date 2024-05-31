function [FDN,F,B,C,D] = makeFDN_dsp(delays, feedbackMatrix, inputGain, outputGain, direct, absorption)


% convert to dsp
A = dspMatrix(feedbackMatrix);
B = dspMatrix(inputGain);
C = dspMatrix(outputGain);
D = dspMatrix(direct);

Z = dspParallelDelay(delays);
G = dspParallelFilters(absorption);

% connect dsp
blockSize = 10000; % TODO: not used
% ZG = dspSequential(Z,G); % absorption is after delay
% F = dspRecursive(blockSize,ZG,A);
F = dspRecursive(blockSize,Z,dspSequential(G,A)); % absorption is before matrix
FDN = dspSequential(dspSequential(B,F),C);

