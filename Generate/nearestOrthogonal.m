function B = nearestOrthogonal(A)
% Compute nearest orthogonal matrix (in the Frobenius norm) via SVD. 
%
% Sebastian J. Schlecht, Wednesday, 29. January 2020

[U,~,V] = svd(A);
B = U*V';

