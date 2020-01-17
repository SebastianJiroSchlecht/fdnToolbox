function [matrix, inputGain, outputGain, direct] = SchroederReverberator(allpassGain, combGain, b, c, d)
%SchroederReverberator - Create combs and allpass as FDN
% see Schlecht, S. (2017). Feedback delay networks in artificial
% reverberation and reverberation enhancement
%
% Syntax:  [matrix, inputGain, outputGain, direct] = SchroederReverberator(g, A)
%
% Inputs:
%    allpassGain - Array of feedforward/back gains for allpass
%    combGain - feedback gains for parallel comb filters
%    b - input gains of comb filters
%    c - output gains of comb filters
%    d - direct gains of comb filters
%
% Outputs:
%   matrix - FDN feedback matrix
%   inputGain - FDN input gains
%   outputGain - FDN output gains
%   direct - FDN direct gain
%
% Example: 
%    
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

[APmatrix, APinputGain, APoutputGain, APdirect] = seriesAllpass(allpassGain);

P = diag(combGain);

S = APinputGain * c;

matrix = [P, 0*P; S, APmatrix];
inputGain = [b; 0*APinputGain'];
outputGain = [APdirect*c; APoutputGain];
direct = d * APdirect;


