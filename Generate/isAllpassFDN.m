function isA = isAllpassFDN(matrix, inputGain, outputGain, direct, varargin)
%Test whether FDN is allpass
% see Michaletzky, G. Factorization Of Discrete–Time All–Pass Functions
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

%% Test for Allpass
U = [matrix, inputGain; outputGain, direct];

P = dlyap(matrix,inputGain*inputGain');
PP = blkdiag(P,1);

testMatrix = U * PP * U' - PP;

% PMP = sqrt(P) \ matrix * sqrt(P) % TODO
% PPUPP = sqrt(PP) \ U * sqrt(PP)

isA = isDiag(P,tol) & isAlmostZero(testMatrix);
