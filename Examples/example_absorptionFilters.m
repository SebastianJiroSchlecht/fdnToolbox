% Example for absorptionFilters
%
% Generate and evaluate recursive absorption filters for given T60 which
% are proportional to the delay lengths
%
% Sebastian J. Schlecht, Saturday, 12. January 2019
clear; clc; close all;

% constants
fs = 48000;

% two target reverbertation times T60 in seconds
targetFrequency = [0; 500; 5000; 8000; fs/2];
targetT60 = [2 2; 2 1; 1 0.5];
targetT60 = [targetT60(1,:); targetT60; targetT60(end,:)];

delayTime = [20, 40]; % ms
delays = ms2smp(delayTime,fs);

filterLength = 10; % ms
filterOrder = 2^nextpow2(ms2smp(filterLength, fs));

% compute absoprtion filters and resulting T60
filterCoefficients = absorptionFilters(targetFrequency, targetT60, filterOrder, delays, fs).';
[T60,T60_f] = absorption2T60( filterCoefficients, delays, 2^10, fs );

% plot
figure(1); hold on; grid on;
plot(filterCoefficients);
legend({'Filter 1','Filter 2'});
xlabel('Time [samples]')
ylabel('Amplitude [lin]')

figure(2); hold on; grid on;
plot(targetFrequency, targetT60)
plot(T60_f, T60);
legend('Target 1','Target 2','Filter Approximation 1','Filter Approximation 2')
xlabel('Frequency [Hz]')
ylabel('T60 [seconds]')
xlim([0,fs/2])


%% Test: Filter Approximation
targetT60Interp = interp1(targetFrequency, targetT60, T60_f);
relativeError = T60 ./ targetT60Interp - 1;
assert( isAlmostZero( relativeError, 'tol', .15 ) ); % below 15%


