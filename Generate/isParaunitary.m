function [isP, testMatrix, maxOffDiagonalValue] = isParaunitary( A, varargin )
%isParaunitary - Determine if matrix A is paraunitary
% A polynomial matrix is paraunitary if A(z)*A^*(z^-1) = I. The function
% determines this property within some numerical tolerance.
%
% Syntax:  [isP, B] = isParaunitary( A, tol )
%
% Inputs:
%    A - Polynomial matrix of size [n,n,order]
%    tol - numerical tolerance (optional)
%
% Outputs:
%    isP - returns true if A is a paraunitary and false otherwise
%    testMatrix - intermediate matrix testMatrix = A(z)*A^*(z^-1) - I
%    maxOffDiagonalValue - maximum off-diagonal value (measure for orthogonality)
%
% Example:
%    isParaunitary( constructCascadedParaunitaryMatrix( 4, 5) )
%    isParaunitary( randn( 3,3,2) )
%
%
% See also: constructParaunitartyMatrix
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% Input parser
persistent p
if isempty(p)
    p = inputParser;
    addRequired(p,'Matrix',@(A) (size(A,1) == size(A,2)) )
    addOptional(p,'tol',eps*1000,@(x) validateattributes(x,...
        {'numeric'},{'scalar'}))
end
p.parse(A,varargin{:});
tol = p.Results.tol;

%% Input sizes
N = size(A,2);
order = size(A,3);

%% Determine paraunitarity
Aconjugate = permute( conj(flip(A,3)), [2 1 3]);

testMatrix = matrixConvolution(A,Aconjugate);

testMatrix(:,:,order) = testMatrix(:,:,order) - eye(N); % shall be close to zero

maxOffDiagonalValue = max(abs(testMatrix(:)));
isP = maxOffDiagonalValue < tol;
