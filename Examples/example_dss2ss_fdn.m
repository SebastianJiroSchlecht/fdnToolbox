% Example for dss2ss and comparison to dss2impz
%
% Sebastian J. Schlecht Monday, 7. January 2019
clear; clc; close all;

%% Lossless feedback matrix
N = 3;
m = [13 19 23];
A = randomOrthogonal(N) * diag(rand(N,1)) * randomOrthogonal(N);
b = randn(N,1);
c = randn(N,1);
d = randn(1,1);

%% State-space transition matrix 
[AA,bb,cc,dd] = dss2ss(m, A, b, c, d);

%% All eigenvalues lie on the unit circle
e = eig(AA);
fprintf('The pole magnitudes are between %f and %f.\n',min(abs(e)),max(abs(e)))

%% Compare impulse response
impulseResponseLength = 100;

[num,den] = ss2tf(AA,bb,cc',dd);
irStateSpace = impz(num,den, impulseResponseLength);

irDelayStateSpace = dss2impz(impulseResponseLength, m, A, b, c.', d);

%% plot
figure(1); hold on; grid on;
plot(irStateSpace)
plot(irDelayStateSpace + 2)
legend({'State Space','Delay State Space'})
xlabel('Time [samples]')
ylabel('Amplitude [linear]')
