function [b,c, maxError] = lowRankApprox(A,n)
% Low rank approximation with singular value decomposition
%
% Syntax:  [b,c, maxError] = lowRankApprox(A,n)
%
% Inputs:
%    A - Input matrix 
%    n - rank of approximation
%
% Outputs:
%    b - output such that b * c' ~= A
%    c - output such that b * c' ~= A
%    maxError - maximum absolute deviation
%
% Example: 
%    [b,c, maxError] = lowRankApprox(randn(5,2)*randn(2,5),2)
%    [b,c, maxError] = lowRankApprox(randn(5,2)*randn(2,5),1)
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 16. June 2020; Last revision: 16. June 2020

%% Largest n singular values
[U,S,V] = svds(A,n);
b = U*sqrt(S) ;
c = sqrt(S)*V';

%% verify
maxError = max(abs( b * c - A), [], 'all');
