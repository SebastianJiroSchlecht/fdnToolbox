% Sebastian J. Schlecht, Saturday, 04 November 2023
clear; clc; close all;

rng(1);

fs = 48000;
impulseResponseLength = fs;

% Define FDN
N = 1;
numInput = 2;
numOutput = 1;
inputGain = ones(N,numInput);
outputGain = ones(numOutput,N);
direct = zeros(numOutput,numInput);
delays = randi([25,40],[1,N]);
feedbackMatrix = fdnMatrixGallery(N,'orthogonal');

len = 1000;
x = randn(len, numInput);
x = zeros(len, numInput);
x(1) = 1;

A = z_FIR(feedbackMatrix);
B = z_FIR(inputGain);
C = z_FIR(outputGain);
% D = z_FIR(constructDelayMatrix(delays));
D = z_DELAY(delays);


y1 = B.filt(x);


y2 = doLoop(A,D,y1);

y3 = C.filt(y2);

y4 = squeeze(y3);
plot(y4)

function output = doLoop(A,D,x)
blkSz = 4;
inputLen = size(x,1);
output = zeros(size(x) + [0,0]); % TODO hack
feedback = zeros(blkSz,size(x,2));
last_s = zeros(blkSz,size(x,2));
s = zeros(blkSz,size(x,2));

blockStart = 0; % TODO hack
while blockStart < inputLen
    if( blockStart + blkSz < inputLen )
        blkInd = blockStart + (1:blkSz);
    else % last block
        break; % TODO: hack
        blkSz = inputLen - blockStart;
        blkInd = blockStart + (1:blkSz);
    end
    
    block = x(blkInd,:);
    
   
    s = D.filt(block + feedback);
    feedback = A.filt( s );

    output(blkInd,:) = s;

    blockStart = blockStart + blkSz;
end

output = output(0+1:end,:);

end
