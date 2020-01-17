function Y = matrix_polyval(P, z)
%matrix_polyval - Evaluate matrix polynomial at z
%
% Syntax:  Y = matrix_polyval(P, z)
%
% Inputs:
%    P - Polynomial matrix [N, M, FIR]
%    z - Evaluation point [scalar]
%
% Outputs:
%    Y - Output matrix [N, M]
%
% Example: 
%    matrix_polyval(randn(3,3,5), 1 + 1i)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 30 December 2019; Last revision: 30 December 2019

degree = size(P,3);
exponents = (degree-1 : -1 : 0)';
zz = permute( z.^exponents, [2 3 1]);

Y = sum(P.*zz,3);
