% Example for allpass but not uniallpass FDN. The FDN is only allpass for
% specific delay lengths, but not for others. 
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Sebastian J. Schlecht, Tuesday, 22. December 2020
clear; clc; close all;

rng(1);
N = 3;

% Start with random orthogonal system matrix for SISO and manipulate it
% with non-diagonal similarity, but only on the first two delays.
V = orth(randn(N+1));

X = eye(N+1);
X(1,1) = -0.1;
X(2,1) = 0.5;

V = X \ V * X;

% Split system matrix into components
A = V(1:end-1,1:end-1);
c = V(end,1:end-1);
b = V(1:end-1,end);
d = V(end,end);

% Principal minors for numerator and denominator of the transfer function
pmA = m2pm(inv(A));
pmDV = m2pm(A-b/d*c);

% print coefficients
printMatLatex(A,'format','%3.3f')
printMatLatex(b.','format','%3.3f')
printMatLatex(c,'format','%3.3f')
printMatLatex(d,'format','%3.3f')

printMatLatex(pmA,'format','%3.2f')
printMatLatex(pmDV,'format','%3.2f')


%% Test: Is allpass (and stable) for m = [1 1 1]
m = [1 1 1];
[isA, den, num] = isAllpass(A,b,c,d,m);

assert(all(abs(roots(den)) < 1))
assert(isA)
printMatLatex(num,'format','%3.2f')
printMatLatex(den,'format','%3.2f')

%% Test: Is not allpass (and not stable) for m = [2 1 1]
m = [2 1 1];
[isA, den, num] = isAllpass(A,b,c,d,m);

assert(any(abs(roots(den)) > 1))
assert(~isA)
printMatLatex(num,'format','%3.2f')
printMatLatex(den,'format','%3.2f')

%% Test: Is allpass (and stable) for m = [2 2 1]
m = [2 2 1];
[isA, den, num] = isAllpass(A,b,c,d,m);

assert(all(abs(roots(den)) < 1))
assert(isA)
printMatLatex(num,'format','%3.2f')
printMatLatex(den,'format','%3.2f')
