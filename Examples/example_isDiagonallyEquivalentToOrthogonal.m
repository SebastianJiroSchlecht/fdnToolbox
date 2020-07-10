% Example for diagonallyEquivalent, isDiagonallyEquivalentToOrthogonal and
% isDiagonallySimilarToOrthogonal
%
% Diagonal manipulation of the feedback matrix is important in the FDN
% theory. diagonallyEquivalent transforms a matrix with diagonal matrices.
% isDiagonallyEquivalentToOrthogonal and isDiagonallySimilarToOrthogonal
% tests whether a matrix is equivalent/similar to an orthogonal matrix. 
%
% see Schlecht, S., Habets, E. (2016). On Lossless Feedback Delay Networks
% IEEE Transactions on Signal Processing  65(6), 1554 - 1564.
% https://dx.doi.org/10.1109/tsp.2016.2637323
%
% Sebastian J. Schlecht, Thursday, 9 January 2020
clear; clc; close all;

rng(1)
N = 5;

% Generate random orthogonal matrix and diagonal matrices
Q = orth(randn(N));
D = diag(randn(N,1)+1);
E = diag(randn(N,1)+1);

A = diagonallyEquivalent(Q,D,E);

%% Test: A is diagonally equivalent to an orthogonal matrix
[isDOE,Q2,D2,E2] = isDiagonallyEquivalentToOrthogonal(A)

assert(isDOE)

%% Test: Is diagonallyEquivalent
B = diagonallyEquivalent(Q,D,inv(D));

[isDOS,Q,D] = isDiagonallySimilarToOrthogonal(B, 'tol', 10^-10)

assert(isDOS)

