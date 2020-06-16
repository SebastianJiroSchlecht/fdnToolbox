function [isA, P] = isAllpassFDN(matrix, inputGain, outputGain, direct, varargin)
%Test whether FDN is allpass
% see Michaletzky, G. Factorization Of Discrete-Time All-Pass Functions
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
% TODO: it's not really testing

P = dlyap(matrix,inputGain*inputGain');



%% verify
U = [matrix, inputGain; outputGain, direct];
PP = blkdiag(P,eye(size(direct)));
testMatrix = U * PP * U' - PP;

isA = isAlmostZero(testMatrix,'tol',tol);
%isDiag(P)

ok = 1;