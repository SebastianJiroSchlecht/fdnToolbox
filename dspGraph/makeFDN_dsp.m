function [FDN,F,B,C,D] = makeFDN_dsp(delays, feedbackMatrix, inputGain, outputGain, direct, absorption)

% define block size of time-domain processing (for rescursion) 
blockSize = min(delays) - 1;

% convert to dsp
A = dspMatrix(feedbackMatrix);
B = dspMatrix(inputGain);
C = dspMatrix(outputGain);
D = dspMatrix(direct);

Z = dspParallelDelay(delays - blockSize);
G = dspParallelFilters(absorption);

% connect dsp
ZG = dspSequential(Z,G);
% F = dspRecursive(blockSize,ZG,A);
F = dspRecursive(blockSize,Z,A);dspSequential(A,G)
FDN = dspSequential(dspSequential(B,F),C);

