function Y = matrix_polyval_batch(P, z, var)
%matrix_polyval - Evaluate matrix polynomial at z
%
% Syntax:  Y = matrix_polyval(P, z)
%
% Inputs:
%    P - Polynomial matrix [N, M, FIR], 
%       with p(1) z^N + ... + p(N-1) z^1 + p(N)
%       or p(1) z^0 + ... + p(N-1) z^-(N-2) + p(N) z^-(N-1) 
%    z - Evaluation point [FT,1]
%
% Outputs:
%    Y - Output matrix [N, M, FT]
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

switch var
    case 'z^1'
        exponents = (degree-1 : -1 : 0);
    case 'z^-1'
        exponents = (0:-1:-(degree-1));
end

zz = z.^exponents;
% Y = einsum(P,zz,'nmt,ft->nmf'); % parsing too expensive
Y = sum(permute(P,[1 2 4 3]) .* permute(zz,[3 4 1 2]),4);

