function [maxDegree, degree] = mpolyDegree(A, varargin)
% deterim

% Sebastian J. Schlecht, Friday, 10 July 2020

degree = zeros(size(A));
for it = 1:numel(A) 
    [~,x] = coeffs(A(it),varargin{:});
    degree(it) = numel(sym2poly(x(1))) - 1;
end

maxDegree = max(degree(:));
