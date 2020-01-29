function B = nearestOrthogonal(A)
% Sebastian J. Schlecht, Wednesday, 29. January 2020
% TODO: document

[U,~,V] = svd(A);
B = U*V';
