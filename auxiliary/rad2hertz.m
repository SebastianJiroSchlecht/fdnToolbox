function hertz = rad2hertz(rad, fs)
% Convert radiant per sample to hertz
%
% Sebastian J. Schlecht, Sunday, 29 December 2019
hertz = rad / (2*pi) * fs;