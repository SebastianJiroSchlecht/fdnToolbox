function V = degreeOneLossless(v)
% V = I - v*v' + z^-1 v*v'
%
% Vaidyanathan, P. P. (1993). Multirate Systems and Filter Banks (pp.
% 1-928). Englewood Cliffs, NJ: Prentice Hall. p. 732

N = size(v,1);
v = v / norm(v);
vv = v*v';

V(:,:,1) = eye(N) - vv;
V(:,:,2) = vv;