% Example for Gardner's Nested Allpass
%
% Gardner, W. G. A real-time multichannel room simulator. J Acoust Soc Am
% 92, 1–23 (1992).
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Sebastian J. Schlecht, Sunday, 7. June 2020
clear; clc; close all;

N = 6;
syms z

g = sym('g', [N,1]);
m = 2.^(0:N-1)';
zm = z.^m; % drop minus for easier readability

[A, b, c, d] = nestedAllpass(g)

%% Test: denominator and numerator are reserved
denominator = coeffs(generalCharPolySym(m, A),z);
numerator = (coeffs(generalCharPolySym(m, A - b*c/d),z) * d);

assert( all((denominator - fliplr(numerator))==0) ) 

%% similarity
X = diag(sym('x',[N,1]));
lyap = A * X * A.' - X + b*b.';
xx = solve(diag(lyap), diag(X));

for i = 1:N % extracted solution
    X(i,i) = (prod(1 - g(i:N).^2));
end 
% for i = 1:N
%     X(i,i) = simplify(xx.(['x' num2str(i)]));
% end

lyapB = simplify(A * X * A.' - X + b*b.')
lyapC = simplify(A.' * inv(X) * A - inv(X) + c.'*c)

assert(all(lyapB(:)==0))
assert(all(lyapC(:)==0))

%% Test: plot
gg = [0.3, 0.4, 0.5,0.6,0.7,0.8]';
AA = subs(A,g,gg)
bb = subs(b,g,gg)
cc = subs(c,g,gg)
dd = subs(d,g,gg)

VV = [AA, bb; cc, dd]

figure(1); hold on;
plotSystemMatrix(AA,bb,cc,dd)

matlab2tikz_sjs(['./plot/matrix_SchroederNested.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');

assert(true)

