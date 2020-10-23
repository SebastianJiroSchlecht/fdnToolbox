% Example for reverberation time and power spectrum estimation.
%
% Test script with synthetically generated noise to evaluate the
% reverberation time estimation method based on the energy decay relief
% (EDR).
%
% Sebastian J. Schlecht, Friday, 23. October 2020

clear; clc; close all;

fs = 48000;

irLen = round(1.1*fs);

RT60 = 0.9;
gainPerSample = db2mag(RT602slope(RT60, fs));

ir = randn(irLen,1) .* gainPerSample .^ (1:irLen)';
[reverberationTimeEarly, reverberationTimeLate, F0, powerSpectrum, edr] = reverberationTime(ir, fs);

% plot
figure(1); hold on; grid on;
plot(F0, reverberationTimeLate)
legend({'Estimation'})
xlabel('Frequency [Hz]')
ylabel('Reverberation Time')
set(gca, 'XScale', 'log')

figure(2); hold on; grid on;
plot(F0, powerSpectrum)
legend({'this'})
xlabel('Frequency [Hz]')
ylabel('Power Spectrum')
set(gca, 'XScale', 'log')

%% Test: script finnished
assert(1 == 1)