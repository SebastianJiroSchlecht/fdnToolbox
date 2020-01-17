function x = clip(x, rangeValues)
% clip values to a given range
%
% Sebastian J. Schlecht, Saturday, 28 December 2019
x = min(max(x,rangeValues(1)),rangeValues(2));
