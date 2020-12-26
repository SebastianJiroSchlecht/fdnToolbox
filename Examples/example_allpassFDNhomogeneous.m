% Sebastian J. Schlecht, Wednesday, 10. June 2020
%
% add description; 
clear; clc; close all;

rng(1);

N = 6;

delays = randi([1 30],[1,N]);
g = 0.99;
G = diag( g.^delays )

P = randAdmissibleHomogeneousAllpass(G, [0.8, 0.99]) % todo minus

R = P*G^2

[A, b, c, d, U] = homogeneousAllpassFDN(G, P,'verbose',true);

[isA, den, num] = isAllpass(A, b, c, d, delays, 'tol', 10^-7)

[isA_wod, den_wod, num_wod] = isAllpass(A, b, c, d*0.001, delays, 'tol', 10^-7)
% P = (diag(diag(P)));

%% plot
% plotMatrix(mag2db(abs(A)))
% colorbar

%% print
(delays)
g

printMatLatex((diag(G)).','format','%3.3f')
printMatLatex((diag(P)).','format','%3.3f')

printMatLatex(U,'format','%3.3f')
printMatLatex(A,'format','%3.3f')
printMatLatex(b.','format','%3.3f')
printMatLatex(c,'format','%3.3f')
printMatLatex(d,'format','%3.3f')

%% plot
close all

figure(1); hold on;
plotSystemMatrix(A,b,c,d)

% matlab2tikz_sjs(['./plot/matrix_HomogeneousSISO.tikz'],'type','standardSingleColumn','height','8.6cm','width','8.6cm');

figure(2); hold on;
freqz(num,den);

figure(3); hold on;
[h,w] = freqz(num_wod,den_wod);
plot(w,(abs(h)))
plot(w,angle(h))

p = roots(den);
plot(angle(p),abs(p),'x');
legend('Magnitude Response without direct','Phase Response','Poles')
xlim([0,pi])


