% Sebastian J. Schlecht, Tuesday, 22. December 2020

clear; clc; close all;

rng(1);

N = 3;

% X = hadamard(N+1)/sqrt(N+1);
% X = fdnMatrixGallery(N+1,'Householder')
X = orth(randn(N+1));
% 
% lX = realLogOfNormalMatrix(X)
% tX = zeros(N+1);
% tX(1,end) = 0.1; lX(1,3)
% tX = tX - tX'
% X = expm(lX + tX)
% eig(X)

R = eye(N+1);
R(1,1) = -0.1;
R(2,1) = 0.5;
% R(3,1) = -0.5;
% R = (randn(N+1))

X = inv(R)* X * R 

A = X(1:end-1,1:end-1);
c = X(end,1:end-1);
b = X(1:end-1,end);
d = X(end,end);

pmA = m2pm(inv(A))

pmDV = m2pm(A-b/d*c)

m = ones(N,1);
[isA, den, num] = isAllpass(A,b,c,d,m)
abs(roots(den))

printMatLatex(num,'format','%3.2f')
printMatLatex(den,'format','%3.2f')

m = [2 1 1]
[isA, den, num] = isAllpass(A,b,c,d,m)
abs(roots(den))

printMatLatex(num,'format','%3.2f')
printMatLatex(den,'format','%3.2f')

% m = [2 2 1]
% [isA, den, num] = isAllpass(A,b,c,d,m)
% abs(roots(den))

m = [2 2 1]
[isA, den, num] = isAllpass(A,b,c,d,m)
abs(roots(den))

printMatLatex(num,'format','%3.2f')
printMatLatex(den,'format','%3.2f')

printMatLatex(A,'format','%3.3f')
printMatLatex(b.','format','%3.3f')
printMatLatex(c,'format','%3.3f')
printMatLatex(d,'format','%3.3f')

printMatLatex(pmA,'format','%3.2f')
printMatLatex(pmDV,'format','%3.2f')
