function [matrix, inputGain, outputGain, direct] = allpassInFDN(g, A, b, c, d)
%allpassInFDN - Create allpass in FDN of size [2N,2N]
% see Schlecht, S. (2017). Feedback delay networks in artificial
% reverberation and reverberation enhancement
%
% Syntax:  [matrix, inputGain, outputGain, direct] = allpassInFDN(g, A)
%
% Inputs:
%    g - Array of feedforward/back gains
%    A - feedback matrix 
%    b - input gains 
%    c - output gains
%    d - direct gains
%
% Outputs:
%   matrix - FDN feedback matrix
%   inputGain - FDN input gains
%   outputGain - FDN output gains
%   direct - FDN direct gain
%
% Example: 
%    allpassInFDN(randn(3,1),randomOrthogonal(3))
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

G = diag(g);
I = eye(size(G));

matrix = [-A*G, A; I - G^2, G];
inputGain = [b; 0*b];
outputGain = [g; c];
direct = d;


