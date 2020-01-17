function d = polydiag( p )
% Sebastian J. Schlecht, Friday, 17. January 2020
%
% Array of polynomials p = [N,FIR], convert to diagonal polynomial matrix d

N = size(p,1);
L = size(p,2);
d = zeros(N,N,L);
for it = 1:N
    d(it,it,:) = p(it,:);
end