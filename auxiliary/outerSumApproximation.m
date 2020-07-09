function [u,v] = outerSumApproximation( A )
% Minimizes || u + v' - A ||_F with a rank-1 approximation
%
% Sebastian J. Schlecht, Tuesday, 27 August 2019

%% Transform to exp domain
maxA = max(A(:));

eA = exp(A/maxA);

%% Rank 1 approximation
[U,S,V] = svd(eA);

eu = U(:,1)*sqrt(S(1,1));
ev = V(:,1)*sqrt(S(1,1));

%% Transform back from exp domain
u = log(abs(eu)) * maxA;
v = log(abs(ev)) * maxA;

