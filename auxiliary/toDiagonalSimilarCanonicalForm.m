function [cA,D] = toDiagonalSimilarCanonicalForm(A)
% modification of Engel, G. M., & Schneider, H. (1982). Algorithms for
% Testing the Diagonal Similarity of Matrices and Related Problems. SIAM.
% J. on Algebraic and Discrete Methods, 3(4), 429-438.
% http://doi.org/10.1137/0603044
%
% Sebastian J. Schlecht, Friday, 15. February 2019
D = diag(A(:,1));
D(1,1) = 1;
cA = inv(D)*A*D; % canonical form with spanning tree from first vertex
