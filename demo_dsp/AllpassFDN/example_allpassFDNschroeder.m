% Example for Schroeder's Series Allpass
%
% Schroeder, M. R. & Logan, B. F. “Colorless” artificial reverberation. IRE
% Transactions on Audio AU-9, 209–214 (1961).
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Sebastian J. Schlecht, Sunday, 7. June 2020
clear; clc; close all;

N = 6;

g = sym('g', [N,1]);
m = 2.^(0:N-1)';

syms z
zm = z.^m; % drop minus for easier readability

[A, b, c, d] = seriesAllpass(g)

% determine similarity
X = diag(sym('x',[N,1]));
lyap = A * X * A.' - X + b*b.';
xx = solve(diag(lyap), diag(X));

X = diag(1 - g.^2) % extracted solution

%% Test: denominator and numerator are reserved
denominator = coeffs(generalCharPolySym(m, A),z);
numerator = (coeffs(generalCharPolySym(m, A - b*c/d),z) * d);

assert( all((denominator - fliplr(numerator))==0) ) 

%% Test: similarity matrix 
lyapB = simplify(A * X * A.' - X + b*b.')
lyapC = simplify(A.' * inv(X) * A - inv(X) + c.'*c)

assert(all(lyapB(:)==0))
assert(all(lyapC(:)==0))

%% Test: plot
gg = [0.3, 0.4, 0.5,0.6,0.7,0.8]';
AA = subs(A,g,gg);
bb = subs(b,g,gg);
cc = subs(c,g,gg);
dd = subs(d,g,gg);
XX = subs(X,g,gg);

VV = [AA, bb; cc, dd];

figure(1); hold on;
plotSystemMatrix(AA,bb,cc,dd)

%matlab2tikz_sjs(['./plot/matrix_SchroederSeries.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');
assert(true) 
