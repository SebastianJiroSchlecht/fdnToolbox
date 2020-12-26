% Sebastian J. Schlecht, Sunday, 7. June 2020
%
% TODO add description; use nested generator 


clear; clc; close all;

N = 6;


g = sym('g', [N,1]);
m = 2.^(0:N-1)';

syms z

zm = z.^m % drop minus for easier readability

[den, num] = nestedSym(g,zm)


sg = [1; g(1:N-1)];
for i = 1:N
    A(i,i) = - g(i)*sg(i);
    
    for j = 1:N
        if i > j
           A(i,j) = -g(i)*sg(j) * prod(1 - g(j:i-1).^2) ;
        end
        
        if i == j-1
           A(i,j) = 1;  
        end
    end
end

b = zeros(N,1);
b(end) = 1;


for i = 1:N
    c(i) = prod(1-g(i:N).^2) * sg(i);
end

d = g(end);

A
b
c
d

H = A - b*c/d
H(2,2)
%% denominator
fliplr( simplify(coeffs(den,z)) )
simplify(coeffs(generalCharPolySym(m, A),z))

%% numerator
fliplr( simplify(coeffs(num,z)))
(coeffs(generalCharPolySym(m, A - b*c/d),z) * d)

%% similarity
% 
P = diag(sym('p',[N,1]))
H = A * P * A.' - P - b*b.'
pp = solve(diag(H), diag(P))
pp.p1
pp.p2

for i = 1:N
    P(i,i) = (-1./ prod(1 - g(i:N).^2));
end
simplify(A * P * A.' - P - b*b.')
simplify(A.' * inv(P) * A - inv(P) - c*c.')

%% plot
close all

gg = [0.3, 0.4, 0.5,0.6,0.7,0.8]';
AA = subs(A,g,gg)
bb = subs(b,g,gg)
cc = subs(c,g,gg)
dd = subs(d,g,gg)

VV = [AA, bb; cc, dd]

figure(1); hold on;
plotSystemMatrix(AA,bb,cc,dd)

matlab2tikz_sjs(['./plot/matrix_SchroederNested.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');



%%


function [den, num] = nestedSym(g,zm)

if numel(g) == 1
    den = 1 + g.*zm;
    num = g + zm;
else
    [denk, numk] = nestedSym(g(1:end-1),zm(1:end-1));
    
    den = 1*denk + g(end).*zm(end)*numk;
    num = g(end)*denk + zm(end)*numk;
end
    

end
