function [isZ, maxVal] = isAlmostZero(A, varargin)
%Test whether matrix / vector is almost zero in absolute values
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
% TODO

%% Input parser
persistent p
if isempty(p)
    p = inputParser;
    addOptional(p,'tol',eps*1000,@(x) validateattributes(x,...
        {'numeric'},{'scalar'}))
end
p.parse(varargin{:});
tol = p.Results.tol;

maxVal = max(abs(A),[],'all');
isZ = maxVal < tol;
