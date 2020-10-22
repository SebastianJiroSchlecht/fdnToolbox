function [isZ, maxVal] = isAlmostZero(A, varargin)
%isAlmostZero - Test whether matrix / vector is almost zero in absolute values
%
% Syntax:  [isZ, maxVal] = isAlmostZero(A, varargin)
%
% Inputs:
%    A - Numerical values to be tested 
%    tol (optional) - Tolerance value for max deviation from 0. Default: eps*1000
%
% Outputs:
%    isZ - Boolean whether all values in A are almost 0
%    maxVal - Maximum absolute value in A
%
% Example: 
%    [isZ, maxVal] = isAlmostZero(randn(20,1)*0.000001, 'tol', 0.00001)
%
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 23. October 2020; Last revision: 23. October 2020

%% Input parser
persistent p
if isempty(p)
    p = inputParser;
    addOptional(p,'tol',eps*1000,@(x) validateattributes(x,...
        {'numeric'},{'scalar'}))
end
p.parse(varargin{:});
tol = p.Results.tol;

maxVal = max(abs(A(:)));
isZ = maxVal < tol;
