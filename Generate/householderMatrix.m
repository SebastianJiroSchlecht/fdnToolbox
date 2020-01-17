function H = householderMatrix(u)
%householderMatrix - Create Householder matrix from vector
%
% Syntax:  H = householderMatrix(u)
%
% Inputs:
%    u - Vector u which is orthogonal to the reflection hyperplane
%
% Outputs:
%    H - Householder transformation matrix
%
% Example: 
%    H = householderMatrix(randn(4,1))
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
% 28 December 2019; Last revision: 28 December 2019

u = u(:);
u = u / norm(u);

N = length(u);
H = eye(N) - 2*(u*u');