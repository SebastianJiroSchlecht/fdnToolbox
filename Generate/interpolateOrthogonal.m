function C = interpolateOrthogonal(A,B,t)
% C = expm( t * logm(A) + (1-t) * logm(B) )
% If A and B are orthogonal than C is orthogonal as well for 0 <= t <= 1  
%
% Sebastian J. Schlecht, Friday, 10. April 2020

C = expm (t * realLogOfNormalMatrix(A) + (1-t) * realLogOfNormalMatrix(B) );