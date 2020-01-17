function RT60 = slope2RT60(slope, fs)
% Convert Energy decay slope to time in seconds of 60dB decay
%
% Sebastian J. Schlecht, Friday, 17. January 2020

% converting from -1dB/sample to -60dB decay in sec 
RT60 = (-60./ clip(slope, [-Inf, -eps]) )./fs;

