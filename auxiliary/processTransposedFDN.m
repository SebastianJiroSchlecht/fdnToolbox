function output = processTransposedFDN(input, delays, A, B, C, D, varargin)
%processTransposedFDN - Time-domain processing of a feedback delay network (FDN)

% A quick version with switching the matrix and delay in the graph.
% Sebastian J. Schlecht, Monday, 23 October 2023

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
    
    %% Delays 
    feedback = DelayFilters.getValues(blkSz);
     
    %% Feedback Matrices and Absorption
    matrixInput = InputGains.filter(block) + feedback;
    matrixOutput = FeedbackMatrix.filter(matrixInput);
    
    if ~isempty(extraMatrix)
        matrixOutput = extraMatrix.filter(matrixOutput);
    end
    
    if ~isempty(absorptionFilters)
       matrixOutput = absorptionFilters.filter(matrixOutput); 
    end

    %% Output
    DelayFilters.setValues(matrixOutput); 
    output(blkInd,:) = OutputGains.filter(matrixOutput);
     

    %% Move to next block
    DelayFilters.next(blkSz);
    blockStart = blockStart + blkSz;
end
