% Example for allpass FDN completion problem. For a given feedback matrix
% A, the goal is to construct b,c, and d, such that the FDN is uniallpass.
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Sebastian J. Schlecht, Tuesday, 9. June 2020
%
clear; clc; close all;
rng(2);


%% Test: complete orthogonal
N = 3;
numIO = 2;
V = randomOrthogonal(N + numIO);
A = V(1:N,1:N);

[b,c,d,PP] = completeOrthogonal(A, numIO, 'verbose', true);
VV = [A,b;c d];

VV*VV' % is orthogonal
assert(isAlmostZero(VV*VV' - eye(size(VV)),'tol',10^-6))

%% Test: complete diagonally similar to orthogonal
N = 3;
numIO = 1;
X1 = blkdiag( diag(rand(N,1)), 1);
V = randomOrthogonal(N+numIO);
XVX = X1 \ V * X1;
XAX = XVX(1:N,1:N);

[b,c,d,X,V] = completeAllpassFDN(XAX, 'verbose', true);

V*V'
assert(isAlmostZero(V*V' - eye(size(V)),'tol',10^-6))

%% Test: complete series allpass
N = 4;
g = rescale(rand(N,1),0.5,0.99);

[A, b, c, d] = seriesAllpass(g);

[b,c,d,X,V] = completeAllpassFDN(A, 'verbose', true);

V*V'
assert(isAlmostZero(V*V' - eye(size(V)),'tol',10^-6))

%% Test: nested allpass - TODO sometimes fails due to poor low rank solution
N = 3;
g = rescale(rand(N,1),0.5,0.99);
[A, b, c, d] = nestedAllpass(g);

[b,c,d,X,V] = completeAllpassFDN(A, 'verbose', true);

V*V'
assert(isAlmostZero(V*V' - eye(size(V)),'tol',10^-6))

%% Test: homogeneous allpass
delays = [32 19 13];
g = 0.99;
G = diag( g.^delays )
X = -diag([0.4, 0.6, .85])
[A, b, c, d] = homogeneousAllpassFDN(G, X, 'verbose', true);
[isA, X] = isUniallpass(A, b, c, d);

[b,c,d,X,V] = completeAllpassFDN(A, 'verbose', true);

V*V'
assert(isAlmostZero(V*V' - eye(size(V)),'tol',10^-6))

