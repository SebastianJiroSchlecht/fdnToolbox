function impulseResponse = mtf2impz(tfB,tfA,impulseResponseLength)
%mtf2impz - synthesize impulse response from a transfer function matrix
%Similar to impz, copmute the impulse response from transfer function.
%Except, the numerator part can be a matrix of polynomials.
%
% Syntax:  impulseResponse = mtf2impz(tfB,tfA,impulseResponseLength)
%
% Inputs:
%    tfB - matrix of numerator part of size [out,in,filter order]
%    tfA - single denominator part of size [1, filter order]
%    impulseResponseLength - length of the impulse response
%
% Outputs:
%    impulseResponse - resulting matrix of impulse responses [out,in,length]
%
% Example: 
%    mtf2impz(randn(3,4,10),[1,0.1],50);
%
%
% See also: impz
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

numOutput = size(tfB,1);
numInput = size(tfB,2);
tfB = permute(tfB,[3 1 2]);

impulseResponse = zeros(numOutput, numInput,impulseResponseLength);

recursivePart = impz(1,tfA,impulseResponseLength);
for itOut = 1:numOutput
    for itIn = 1:numInput
       directPart =  tfB(:,itOut,itIn);
       ir = conv(recursivePart, directPart); 
       impulseResponse(itOut,itIn,:) = ir(1:impulseResponseLength);
    end
end