function determinant = detPolynomial( polynomialMatrix, var )
%detPolynomial - Determinant of a polynomial matrix
% Algorithm described in
% "Some Algorithms used in the Polynomial Toolbox for Matlab" by Didier
% Henrion , Martin Hromcik , Michael Sebek in 2000
%
% Syntax:  determinant = detPolynomial( polynomialMatrix, var )
%
% Inputs:
%    polynomialMatrix - Polynomial Matrix of size [N,N,degree]
%    var - Either 'z^1' or 'z^-1'
%
% Outputs:
%    determinant - Return determinant polynomial
%
% Example: 
%    detPolynomial( randn(4,4,16), 'z^-1' )
%    detPolynomial( constructCascadedParaunitaryMatrix(4,1) , 'z^-1' )
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
% 29 December 2019; Last revision: 29 December 2019


tol = -200; % in dB
[~,N,len] = size(polynomialMatrix);
fftSize = len*N;

%% computation
switch var
    case 'z^-1'
        freqMat = fft(polynomialMatrix,fftSize,3);
    case 'z^1'
        freqMat = fft(flip(polynomialMatrix,3),fftSize,3);
    otherwise
        error('Not defined');    
end


freqDet = zeros(fftSize,1);
for it=1:fftSize
    freqDet(it) = det( freqMat(:,:,it) );
end

determinant = ifft(freqDet,fftSize);
determinant = determinant(1:end-(N-1));

%% shorten the determinant numerically
switch var
    case 'z^-1'
        degree = polyDegree(determinant, var, tol);
        determinant = determinant(1:degree+1);
    case 'z^1'
        determinant = flipud(determinant);
        degree = polyDegree(determinant, var, tol);
        determinant = determinant(end-degree:end);
end

