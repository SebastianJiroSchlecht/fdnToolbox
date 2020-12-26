% Sebastian J. Schlecht, Sunday, 7. June 2020
%
% add description; use series generator

clear; clc; close all;

N = 6;


g = sym('g', [N,1]);
m = 2.^(0:N-1)';

syms z

zm = z.^m % drop minus for easier readability

A = diag(-g);
for i = 1:N
    for j = 1:N
        if i > j
           A(i,j) = (1 - g(j)^2) * prod( g(j+1:i-1) ); 
        end
    end
end

for i = 1:N
%     b(i) = (1./g(i) - g(i)) .* prod(-g(1:i));
    b(i) = prod(g(1:i-1))
end
b = b.';

for i = 1:N
%     c(i) = 1./g(i) * prod( -g(N-i+1:N) ); 
    c(i) = (1-g(i)^2) * prod( g(i+1:N) )
end

d = prod(g)

A
b
c
d

H = A - b*c/d
H(2,2)
%% denominator
fliplr( coeffs(prod( 1 + g.*zm ),z) )
coeffs(generalCharPolySym(m, A),z)

%% numerator
fliplr( coeffs(prod( g + zm ),z) )
pretty(coeffs(generalCharPolySym(m, A - b*c/d),z) * d)

%% similarity
P = diag(sym('p',[N,1]))
H = A * P * A.' - P + b*b.'
pp = solve(diag(H), diag(P))

P = diag(1./ (1 - g.^2))

simplify(A * P * A.' - P + b*b.')
simplify(A.' * inv(P) * A - inv(P) + c.'*c)


%% plot
close all

gg = [0.3, 0.4, 0.5,0.6,0.7,0.8]';
AA = subs(A,g,gg)
bb = subs(b,g,gg)
cc = subs(c,g,gg)
dd = subs(d,g,gg)
PP = subs(P,g,gg)

VV = [AA, bb; cc, dd]

figure(1); hold on;
plotSystemMatrix(AA,bb,cc,dd)

%matlab2tikz_sjs(['./plot/matrix_SchroederSeries.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');

