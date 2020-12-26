% Sebastian J. Schlecht, Tuesday, 16. June 2020
%
% TODO add description

clear; clc; close all;

N = 4;

U = randomOrthogonal(N);

g = 0.7;

[A,B,C,D] = polettiAllpass(g, U)

%% check uniallpass
[isA, P] = isUniallpass(A,B,C,D)

delays = 2.^(0:N-1);
[isA, den, num] = isAllpass(A, B, C, D, delays)

%% plot
close all

figure(1); hold on;
plotSystemMatrix(A,B,C,D)

matlab2tikz_sjs(['./plot/matrix_polettiMIMO.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');
