% Example for Poletti's Allpass FDN for multi-input-output (MIMO)
%
% based on Poletti, M. A. A Unitary Reverberator For Reduced Colouration In
% Assisted Reverberation Systems. in vol. 5 1223–1232 (1995).
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Sebastian J. Schlecht, Saturday 26. December 2020
clear; clc; close all;

N = 4;

U = randomOrthogonal(N);

g = 0.7;

[A,B,C,D] = polettiAllpass(g, U)

% plot
figure(1); hold on;
plotSystemMatrix(A,B,C,D)

matlab2tikz_sjs(['./plot/matrix_polettiMIMO.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');

%% Test: check uniallpass
[isA, P] = isUniallpass(A,B,C,D)
assert(isA)

%% Test: check determinant allpass
delays = 2.^(0:N-1);
[isA, den, num] = isAllpass(A, B, C, D, delays)
assert(isA)

%% Test: check impulse response is paraunitary
irLen = 1000;
impulseResponse = dss2impz(irLen, delays, A, B, C, D);
impulseResponse = permute(impulseResponse,[2 3 1]);
[isP, testMatrix, maxOffDiagonalValue] = isParaunitary(impulseResponse);
assert(isP)

