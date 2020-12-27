function A = mat(v)
% Reverse vec operation for square matrices A: A = mat(vec(A))
%
% Sebastian J. Schlecht, Saturday, 9. May 2020

N = sqrt(numel(v));
A = reshape(v,N,N);
