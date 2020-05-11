function Q = randomOrthogonal(n)
% Generates a random n x n orthogonal real matrix
%
% Matrix distributed according to the Haar measure over the group of
% orthogonal matrices. The Haar measure provides a uniform distribution
% over the orthogonal matrices.
%
% Based on Nick Higham
% https://nhigham.com/2020/04/22/what-is-a-random-orthogonal-matrix/

[Q,R] = qr(randn(n));
Q = Q*diag(sign(diag(R)));

