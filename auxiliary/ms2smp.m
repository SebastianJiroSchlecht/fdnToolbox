function x = ms2smp(x, fs)
% Convert milliseconds to sample
%
% Sebastian J. Schlecht, Friday, 17. January 2020

x = round(x * fs / 1000);