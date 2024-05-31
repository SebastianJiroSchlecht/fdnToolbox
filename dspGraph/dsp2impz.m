function impulseResponse = dsp2impz(irLen, FDN, varargin)
%dss2impz - From state-space to impulse response
% Uses the standard time-domain recursion to compute the impulse response
% of the given feedback delay network (FDN).
%
% Syntax:  impulseResponse = dss2impz(irLen, delays, A, B, C, D, type)
%
% Inputs:
%    irLen - length of impulse response in samples
%    delays - delays in samples of size [1,N]
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)] or TF
%    B - input gains of size [N,in]
%    C - output gains of size [out,N]
%    D - direct gains of size [out,in]
%    varargin - see processFDN
%
% Outputs:
%    impulseResponse - matrix of impulse response [irLen,out,in]
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: Friday, 17. January 2020

% TODO split input is missing


%% Create dirac pulse
blockSize = FDN.blockSize;

input = zeros(irLen, FDN.numberOfInputs);
input(1+blockSize,:) = 1;

% time-domain processing
blockStart = 0;

impulseResponse = zeros(irLen,FDN.numberOfOutputs);

while (blockStart < irLen - blockSize) % fix the last block
    blockIndex = blockStart + (1:blockSize);
    block = input(blockIndex,:);
    
    impulseResponse(blockIndex,:) = FDN.process(block);

    blockStart = blockStart + blockSize;
end