function C = matrixConvolution(A,B)
%matrixConvolution - matrix polynomial multiplication
% Multiply two matrix polynomials A and B by convolution.
%
% Syntax:  C = matrixConvolution(A,B)
%
% Inputs:
%    A - matrix polynomial of size [m,n,order]
%    B - matrix polynomial of size [n,k,order]
%
% Outputs:
%    C - matrix polynomial of size [m,k,order] with C(z) = A(z)+B(z)
%
% Example: 
%    C = matrixConvolution(randn(3,2,4),randn(2,1,5));
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019


szA = [size(A,1), size(A,2), size(A,3)];
szB = [size(B,1), size(B,2), size(B,3)];

if( szA(2) ~= szB(1) )
   error('Invalid matrix dimesion.') 
end

C = zeros( szA(1), szB(2), szA(3) + szB(3) - 1 );

A = permute(A,[3,1,2]);
B = permute(B,[3,1,2]);
C = permute(C,[3,1,2]);

for row = 1:szA(1)
    for col = 1:szB(2)
        for it = 1:szA(2)
            C(:,row,col) = C(:,row,col) + conv( A(:,row,it), B(:,it,col)  );
        end
    end
end

C = permute(C,[2,3,1]);



