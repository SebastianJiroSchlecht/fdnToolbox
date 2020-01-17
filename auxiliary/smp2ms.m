function ms = smp2ms(smp, fs)
% Convert sample to milliseconds
%
% Sebastian J. Schlecht, Friday, 17. January 2020

ms = smp / fs * 1000;