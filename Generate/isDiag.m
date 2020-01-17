function isD = isDiag(matrix, varargin)
%Test whether matrix is almost diagonal (depending on tolerance)
%
% Sebastian J. Schlecht, Saturday, 28 December 2019

%% Input parser
persistent p
if isempty(p)
    p = inputParser;
    addOptional(p,'tol',eps*1000,@(x) validateattributes(x,...
        {'numeric'},{'scalar'}))
end
p.parse(varargin{:});
tol = p.Results.tol;

isD = isAlmostZero( matrix - diag(diag(matrix)), tol);