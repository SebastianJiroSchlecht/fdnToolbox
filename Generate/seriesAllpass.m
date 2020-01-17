function [matrix, inputGain, outputGain, direct] = seriesAllpass(g)
%nestedAllpass - Create series allpass as FDN 
%
% Syntax:  [matrix, inputGain, outputGain, direct] = seriesAllpass(g)
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
%    seriesAllpass(randn(3,1))
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
    [matrix, inputGain, outputGain, direct] = seriesFDNinAllpass(g(it), matrix, inputGain, outputGain, direct);
end


function [S_matrix, S_inputGain, S_outputGain, S_direct] = seriesFDNinAllpass(allpassGain, matrix, inputGain, outputGain, direct)
% Series connection of an FDN with a feedforward/back allpass filter 

g2 = 1 - allpassGain^2;
S_matrix = [matrix, 0*inputGain; outputGain*g2, allpassGain];

S_inputGain = [ inputGain; direct*(g2)];

S_outputGain = [ -allpassGain*outputGain, 1];

S_direct = -allpassGain*direct;
