function x = snap(x, valueArray)
% Snap values to the closest value in the array
%
% Sebastian J. Schlecht, Friday, 17. January 2020

[~,index] = min(abs(bsxfun(@minus, valueArray, x)),[],2);
x = valueArray(index);
