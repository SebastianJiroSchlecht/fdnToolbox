function impulseResponse = dsp2impz(irLen, FDN, domain, varargin)
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

switch domain
    case 'time'
        %% Create dirac pulse
        blockSize = FDN.blockSize;

        input = zeros(irLen, FDN.numberOfInputs);
        input(1,:) = 1;

        % time-domain processing
        blockStart = 0;

        impulseResponse = zeros(irLen,FDN.numberOfOutputs);

        while (blockStart < irLen - blockSize) % TODO: fix the last block
            blockIndex = blockStart + (1:blockSize);
            block = input(blockIndex,:);

            impulseResponse(blockIndex,:) = FDN.process(block);

            blockStart = blockStart + blockSize;
        end

        impulseResponse = circshift(impulseResponse,blockSize,1);

    case 'frequency'
        % frequency-domain sampling
        gainPerSample = db2mag(120 / irLen); % extra damping to avoid aliasing

        w = circspace(irLen).';
        z = gainPerSample * exp(1i .* w);

        X = ones(numel(w),FDN.numberOfInputs,FDN.numberOfOutputs);
        
        Fz = FDN.at(X,z,'z^-1');

        impulseResponse = real(ifft(Fz));

        impulseResponse = gainPerSample.^(0:irLen-1)' .* impulseResponse; % compensate extra damping
end