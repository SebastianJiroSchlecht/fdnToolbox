function [isA, P] = isUniallpass(matrix, inputGain, outputGain, direct, varargin)
% isUniallpass - Test whether FDN is uniallpass
%
% see Allpass FDN by Sebastian J. Schlecht
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

%% Test for Uniallpass
P = dlyap(matrix,inputGain*inputGain');

if isDiag(P, 'tol', tol)
    P = diag(diag(P));
    
    U = [matrix, inputGain; outputGain, direct];
    PP = blkdiag(P,eye(size(direct)));
    testMatrix = PP - U * PP * U';
    isA = isAlmostZero(testMatrix,'tol',tol);   
else
    isA = false;
end