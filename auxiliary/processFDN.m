function output = processFDN(input, delays, A, B, C, D, varargin)
%processFDN - Time-domain processing of a feedback delay network (FDN)
% Uses the standard time-domain recursion to process the input sound with
% the given feedback delay network (FDN).
%
% Syntax:  output = processFDN(input, delays, A, B, C, D, type)
%
% Inputs:
%    input - input sound [length, numberOfInputs]
%    delays - delays in samples of size [1,N]
%    A - feedback matrix of size [N,N]: scalar, polynomial or zFilter
%    B - input gains of size [N,in]: like above
%    C - output gains of size [out,N]: like above
%    D - direct gains of size [out,in]: only scalar
%    inputType (optional) - either 'splitInput' (default), 'mergeInput'
%    extraMatrix (optional) - e.g. time-varying matrix
%    absorptionFilters (optional) - filters of size [N,1]
%
% Outputs:
%    output - multichannel output [length,out] (mergeInput) or
%    [length,out,in] (splitInput)
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 2020-10-23

%% Input Parser
p = inputParser;
p.addParameter('inputType','mergeInput',@(x) ischar(x) );
p.addParameter('extraMatrix',[]);
p.addParameter('absorptionFilters',eye(numel(delays)));
parse(p,varargin{:});

inputType = p.Results.inputType;
extraMatrix = p.Results.extraMatrix;
absorptionFilters = p.Results.absorptionFilters;

%% Initialize
A = convert2zFilter(A);
B = convert2zFilter(B);
C = convert2zFilter(C);
numInput = B.m;
numOutput = C.n;
inputLen = size(input,1);

%% Process
switch inputType
    case 'splitInput'
        output = zeros(inputLen, numOutput, numInput);
        splitGain = zeros(1,numInput);
        for itIn = 1:numInput
            splitGain(:) = 0;
            splitGain(itIn) = 1;
            output(:,:,itIn) = computeFDNloop(input .* splitGain, delays, A, B, C, extraMatrix, absorptionFilters);
        end
        output = output + permute( input, [1 3 2]) .* permute( D, [3 1 2]) ;
        
    case 'mergeInput'
        output = computeFDNloop(input, delays, A, B, C, extraMatrix, absorptionFilters);
        output = output + input * D.';
end




function output = computeFDNloop(input, delays, feedbackMatrix, inputGains, outputGains, extraMatrix, absorptionFilters)
%% Compute the FDN time domain loop
maxBlockSize = 2^12;
blkSz = min([min(delays), maxBlockSize]);

%% Convert to dfilt
DelayFilters = feedbackDelay(maxBlockSize,delays);
FeedbackMatrix = dfiltMatrix(feedbackMatrix);
InputGains = dfiltMatrix(inputGains);
OutputGains = dfiltMatrix(outputGains);
absorptionFilters = dfiltMatrix(absorptionFilters); 

%% Time-domain recursion
inputLen = size(input,1);
output = zeros(inputLen, OutputGains.n);

blockStart = 0;
while blockStart < inputLen
    if( blockStart + blkSz < inputLen )
        blkInd = blockStart + (1:blkSz);
    else % last block
        blkSz = inputLen - blockStart;
        blkInd = blockStart + (1:blkSz);
    end
    
    block = input(blkInd,:);
    
    %% Delays and Absorption
    delayOutput = DelayFilters.getValues(blkSz);
    if ~isempty(absorptionFilters)
       delayOutput = absorptionFilters.filter(delayOutput); 
    end
    
    %% Feedback Matrices
    feedback = FeedbackMatrix.filter(delayOutput);
    if ~isempty(extraMatrix)
        feedback = extraMatrix.filter(feedback);
    end
    
    %% Input and Output
    delayLineInput = InputGains.filter(block) + feedback;
    DelayFilters.setValues(delayLineInput);
    
    output(blkInd,:) = OutputGains.filter(delayOutput);
    
    %% Move to next block
    DelayFilters.next(blkSz);
    blockStart = blockStart + blkSz;
end
