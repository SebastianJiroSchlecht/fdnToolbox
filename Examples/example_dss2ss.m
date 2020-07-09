% Example for dss2ss and comparison to dss2impz
%
% FDNs are typically represented in delay state-space (dss), but can be
% also given in standard state-space (ss). This example demonstrates
% conversion dss2ss and the verification based on the impulse response.
%
% Sebastian J. Schlecht Monday, 7. January 2019
clear; clc; close all;
rng(1);


% Lossless feedback matrix
N = 3;
m = [13 19 23];
g = 0.9;
A = randomOrthogonal(N) * diag(g.^m);
b = randn(N,1);
c = randn(1,N);
d = randn(1,1);

% State-space transition matrix 
[AA,bb,cc,dd] = dss2ss(m, A, b, c, d);


% Compare impulse response
impulseResponseLength = 100;

[num,den] = ss2tf(AA,bb,cc,dd);
irStateSpace_TF = impz(num,den,impulseResponseLength);

[sos,sos_g] = ss2sos(AA,bb,cc,dd);
irStateSpace_SOS = sos_g*impz(sos,impulseResponseLength);

irDelayStateSpace = dss2impz(impulseResponseLength, m, A, b, c, d);

% plot
figure(1); hold on; grid on;
plot(irStateSpace_TF)
plot(irStateSpace_SOS + 2)
plot(irDelayStateSpace + 4)
legend({'State Space TF','State Space SOS','Delay State Space'})
xlabel('Time [samples]')
ylabel('Amplitude [linear]')

%% Test: All eigenvalues lie on the circle with radius g
e = eig(AA);
fprintf('The pole magnitudes are between %f and %f.\n',min(abs(e)),max(abs(e)))
assert( isAlmostZero( abs(e) - g ))

%% Test: Transfer function representation  
assert(isAlmostZero(irStateSpace_TF - irDelayStateSpace, 'tol', 0.001))

%% Test: Second-order section representation
assert(isAlmostZero(irStateSpace_SOS - irDelayStateSpace, 'tol', 10^-12))
