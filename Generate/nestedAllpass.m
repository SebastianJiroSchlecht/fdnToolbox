function [matrix, inputGain, outputGain, direct] = nestedAllpass(g)
%nestedAllpass - Create nested allpass as FDN 
%
% Syntax:  [matrix, inputGain, outputGain, direct] = nestedAllpass(g)
%
% Inputs:
%    g - Array of feedforward/back gains
%
% Outputs:
%   matrix - FDN feedback matrix
%   inputGain - FDN input gains
%   outputGain - FDN output gains
%   direct - FDN direct gain
%
% Example: 
%    nestedAllpass(randn(3,1))
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: isAllpassFDN
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Initialize feedforward/back allpass filter 
matrix = g(1);
inputGain = 1-g(1)^2;
outputGain = 1;
direct = -g(1);

%% Iterative nesting of feedforward/back allpass filters
for it = 2:length(g)
    [matrix, inputGain, outputGain, direct] = nestingFDNinAllpass(g(it), matrix, inputGain, outputGain, direct);
end



function [N_matrix, N_inputGain, N_outputGain, N_direct] = nestingFDNinAllpass(allpassGain, matrix, inputGain, outputGain, direct)
% Nest a FDN within an feedforward/back allpass filter 

N_matrix = [matrix, inputGain; outputGain*allpassGain, direct*allpassGain];

N_inputGain = [ 0*inputGain; 1 - allpassGain^2];

N_outputGain = [ outputGain, direct];

N_direct = -allpassGain;
