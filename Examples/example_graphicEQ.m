% Example for graphic EQ filter design
%
% All About Audio Equalization: Solutions and Frontiers
% by V. Välimäki and J. Reiss, 
% in Applied Sciences, vol. 6, no. 5, p. 129, May 2016.
%
%
% *Reproduce in Code*
% (c) Sebastian Jiro Schlecht:  Monday, 7. January 2019
% 

close all; clear; clc; 
fftLen = 2^16;
fs = 48000;

targetG = [1; -1; 1; -1; 1; -1; 1; -1; 1; 1]*10; % dB

[optimalSOS, targetF] = designGEQ(targetG);
[hOpt,wOpt] = freqz(optimalSOS,fftLen,fs);

% plot
figure(2); hold on; grid on; 
plot(targetF, targetG);
plot(wOpt,mag2db(abs(hOpt)))
set(gca, 'xScale', 'log')
ylim([-12 12])
xlim([10 fs/2])
title('Approximation Magnitude Response')
legend('Target', 'Actual EQ', 'Location','SouthEast');

%% Test: Graphic EQ design
assert( 1 == 1); % script runs without error  
