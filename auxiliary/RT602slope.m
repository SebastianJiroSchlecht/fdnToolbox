function slope = RT602slope(RT60, fs)
% Convert time (in seconds) of 60dB decay to energy decay slope
%
% Sebastian J. Schlecht, Friday, 17. January 2020

% converting from -60dB decay in sec to -1dB/sample
slope = -60./(RT60.*fs); 