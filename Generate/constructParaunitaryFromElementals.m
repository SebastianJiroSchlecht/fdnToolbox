function matrix = constructParaunitaryFromElementals( N, degree )
%constructParaunitaryFromElementals - Create random paraunitary matrix
% Construct paraunitary matrix as a sucession of random parunitary delays
% and rotations. The details are outlined in
% Vaidyanathan, P. P. (1993). Multirate Systems and Filter Banks (pp.
% 1-928). Englewood Cliffs, NJ: Prentice Hall. p. 732
%
% Syntax:  matrix = constructParaunitartyMatrix( N, degree )
%
% Inputs:
%    N - Size of the paraunitary matrix
%    degree - Polynomial degree of the matrix
%
% Outputs:
%    matrix - Random paraunitary matrix of size [N,N,degree]
%
% Example:
%    constructParaunitaryFromElementals( 3, 5 )
%
% See also: isParaunitary
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 27 December 2019; Last revision: 27 December 2019

%% construct paraunitary matrix
matrix = zeros(N, N, 1);
matrix(:,:,1) = orth(randn(N));

for it=2:degree
    v = randn(N,1);
    rot = degreeOneLossless(v);
    matrix = matrixConvolution(matrix,rot);
end


function rot = degreeOneLossless(v)
N = length(v);
v = v / norm(v);
V = v*v';

rot(:,:,1) = eye(N) - V;
rot(:,:,2) = V;
