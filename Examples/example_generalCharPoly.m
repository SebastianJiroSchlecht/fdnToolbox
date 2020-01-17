% example generalCharPoly and generalCharPolySym
%
% see Schlecht, S. J., & Habets, E. A. P. (2017). On lossless feedback
% delay networks. IEEE Trans. Signal Process., 65(6), 1554–1564.
% http://doi.org/10.1109/TSP.2016.2637323 
% Sebastian J. Schlecht Monday, 7.January 2019
clear; clc; close all;

%% Non-Unilossless Matrix with different delays
disp('Non-Unilossless Matrix example')
d = [1,2]; % delay in samples
A = [3,2;-4,-3]; % feedback matrix

eigenvaluesOfA = eig(A) % eigenvalues are on the unit circle
pSym = generalCharPolySym(d,A)
pDirect = generalCharPoly(d,A)
abs(roots(pDirect)).'

disp(' ... with different delay');
d = [2,1];

p = generalCharPoly(d,A)
rootsOfP = abs(roots(p)).'


%% Allpass Matrix
disp('Allpass Matrix');
d = [3,1];
g = 0.5;
A = [-g, 1; 1-g^2, g];

p = generalCharPoly(d,A)
rootsOfP = abs(roots(p)).'

%% Diagonally conjugated Matrix
disp('Diagonally conjugated Matrix');
d = [3,2];
g = 0.5;
D = diag([0.1 -1]);
O = orth(randn(2));
A = D * O * inv(D);

p = generalCharPoly(d,A)
rootsOfP = abs(roots(p)).'

%% Polynomial Matrix example
disp('Polynomial Matrix example')
syms z;
rng(1);
N = 2;
d = [13,9];
A = randn(N, N, 3);

[p,m] = generalCharPoly(d,A)
pSym = generalCharPolySym(d,mpoly2sym(A));
[num,den] = numden(pSym);
num = sym2poly(num);
den = sym2poly(den);
num = num / den(1)
den = den / den(1)

%% Polynomial Delay Matrix example
disp('Polynomial Delay Matrix example')

N = 2;
d = [3,2];
H = hadamard(N)/sqrt(N);

% delay in matrix
A = zeros(N, N, 3);
A(:,:,end) = H;

p = generalCharPoly(d,A)
p = generalCharPolySym(d,mpoly2sym(A))

% delay in delay
A = H;
additionalDelay = 2;
p = generalCharPoly(d+additionalDelay,A)
p = generalCharPolySym(d+additionalDelay,mpoly2sym(A))


