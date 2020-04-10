function [isDOS,Q,D] = isDiagonallySimilarToOrthogonal(A, varargin)
% Tests whether A is diagonally similar to an orthogonal matrix by first
% testing whether is equivalent to an orthogonal matrix. 
%
% Sebastian J. Schlecht, Friday, 10. April 2020
[isDOE,Q,D,E] = isDiagonallyEquivalentToOrthogonal(A);

isDOS = isDOE & isAlmostZero( inv(D)-E, varargin{:} );

