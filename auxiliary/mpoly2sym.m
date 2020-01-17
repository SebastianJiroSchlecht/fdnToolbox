function S = mpoly2sym(A,z)
%mpoly2sym - convert matrix polynomial to symbolic matrix polynomial
%
% Syntax:  S = mpoly2sym(A)
%
% Inputs:
%    A - Matrix polynomial size(A) = [m, n, polynomial order];
%    polynomial order = z^0 + z^-1 + ... + z^-k
%
% Outputs:
%    S - Symbolic matrix polynomial
%
% Example:
%    Line 1 of example
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

if nargin == 1
    syms z;
end
switch ndims(A)
    case 3 % polynomial matrix
        [m, n, order] = size(A);
        S = sym(zeros(m,n));
        
        for itM = 1:m
            for itN = 1:n
                S(itM,itN) = poly2sym(A(itM,itN,:),z);
            end
        end
        S = expand(S / z^(order-1));
    case 2 % scalar matrix
        S = A;
    otherwise
        error('not defined')
end

