function hertz = unit2hertz(unit, fs)
% unit2hertz - Convert  frequency from normalized to cycles per second
%
% Sebastian J. Schlecht, Friday, 17. January 2020
hertz = unit / 2 * fs;