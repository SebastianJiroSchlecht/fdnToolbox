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
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)] or TF
%    B - input gains of size [N,in]
%    C - output gains of size [out,N]
%    D - direct gains of size [out,in]
%    inputType (optional) - either 'splitInput', 'mergeInput'
%    extraMatrix (optional) - e.g. time-varying matrix
%    absorptionFilters (optional) - filters of size [N,1]
%
% Outputs:
%    output - matrix of impulse response [length,out,in]
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Input Parser
p = inputParser;
p.addParameter('inputType','mergeInput',@(x) ischar(x) );
p.addParameter('extraMatrix',[]);
p.addParameter('absorptionFilters',[]);
parse(p,varargin{:});

inputType = p.Results.inputType;
extraMatrix = p.Results.extraMatrix;
absorptionFilters = p.Results.absorptionFilters;

%% Process
numInput = size(B,2);
numOutput = size(C,1);
inputLen = size(input,1);
switch inputType
    case 'splitInput'
        output = zeros(inputLen, numOutput, numInput);
        for itIn = 1:numInput
            output(:,:,itIn) = loopSub(input(:,itIn), delays, A, B(:,itIn), C, extraMatrix, absorptionFilters);
        end
        output = output + permute( input, [1 3 2]) .* permute( D, [3 1 2]) ;
        
    case 'mergeInput'
        output = loopSub(input, delays, A, B, C, extraMatrix, absorptionFilters);
        output = output + input * D.';
end




function output = loopSub(input, delays, feedbackMatrix, inputGains, outputGains, extraMatrix, absorptionFilters)
%% FDN loop

maxBlockSize = 2^12;
DelayFilters = feedbackDelay(maxBlockSize,delays);
FeedbackMatrix = filterMatrix(feedbackMatrix);
InputGains = filterMatrix(inputGains);
OutputGains = filterMatrix(outputGains);
absorptionFilters = zFilter2dfilt(absorptionFilters); 


blkSz = min([min(delays), maxBlockSize]);

inputLen = size(input,1);
output = zeros(inputLen, OutputGains.numberOfOutputs);

%% Time-domain recursion
blockStart = 0;
while blockStart < inputLen
    if( blockStart + blkSz < inputLen )
        blkInd = blockStart + (1:blkSz);
    else % last block
        blkSz = inputLen - blockStart;
        blkInd = blockStart + (1:blkSz);
    end
    
    block = input(blkInd,:);
       
    delayOutput = DelayFilters.getValues(blkSz);
    if ~isempty(absorptionFilters)
       delayOutput = absorptionFilters.filter(delayOutput); 
    end
    
    
    feedback = FeedbackMatrix.filter(delayOutput);
    if ~isempty(extraMatrix)
        feedback = extraMatrix.filter(feedback);
    end
    
    delayLineInput = InputGains.filter(block) + feedback;
    DelayFilters.setValues(delayLineInput);
    
    output(blkInd,:) = OutputGains.filter(delayOutput);
    
    DelayFilters.next(blkSz);
    blockStart = blockStart + blkSz;
end
