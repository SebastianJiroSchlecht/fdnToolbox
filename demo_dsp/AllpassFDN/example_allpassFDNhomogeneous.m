% Example for an allpass FDN with homogeneous decay such that all poles
% have the same decay rate.
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Sebastian J. Schlecht, Wednesday, 10. June 2020
clear; clc; close all;

rng(1);

N = 6;

delays = randi([1 30],[1,N]); % delays in samples
g = 0.99; % global gain per sample
G = diag( g.^delays ) % gain matrix

% diagonal similarity
X = randAdmissibleHomogeneousAllpass(G, [0.8, 0.99]) 
R = X*G^2

% create allpass FDN
[A, b, c, d, U] = homogeneousAllpassFDN(G, X,'verbose',true);

%% Test: is determinant allpass
[isA, den, num] = isAllpass(A, b, c, d, delays, 'tol', 10^-7)
assert(isA)

%% Test: plot
figure(1); hold on;
plotSystemMatrix(A,b,c,d)

matlab2tikz_sjs(['./plot/matrix_HomogeneousSISO.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');

% print results
disp(delays)
disp(g)

printMatLatex((diag(G)).','format','%3.3f')
printMatLatex((diag(X)).','format','%3.3f')

printMatLatex(U,'format','%3.3f')
printMatLatex(A,'format','%3.3f')
printMatLatex(b.','format','%3.3f')
printMatLatex(c,'format','%3.3f')
printMatLatex(d,'format','%3.3f')

assert(true)