function [A, isLossless] = fdnMatrixGallery(N,matrixType,varargin)
%fdnMatrixGallery - Collection of matrices for FDNs
%
% Syntax:  A = fdnMatrixGallery(N,matrixType)
%
% Inputs:
%    N - Matrix size 
%    matrixType - String of type, e.g., 'orthogonal', 'Hadamard', ...
%
% Outputs:
%    A - Feedback matrix of size [N,N]
%    isLossless - Logical value whether matrix is lossless or not
%
% Example: 
%    A = fdnMatrixGallery(4,'orthogonal')
%    A = fdnMatrixGallery(8,'Hadamard')
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

%% get Types, when no argument is provided
if nargin == 0
   A = {'orthogonal','Hadamard','circulant','Householder','parallel','series','diagonalConjugated','tinyRotation',...
       'allpassInFDN','nestedAllpass','SchroederReverberator','AndersonMatrix'};
   return;
end

%% get Matrix 
switch matrixType
    case 'orthogonal'
        A = randomOrthogonal(N);
        isLossless = true;
    case 'Hadamard'
        A = hadamard(N)/sqrt(N);
        isLossless = true;
    case 'circulant'
        R = fft(randn(N,1));
        R = R./abs(R);
        r = ifft(R);
        A = circulant(r,randSgn(1));
        isLossless = true;
    case 'Householder'
        A = householderMatrix(rand(N,1));
        isLossless = true;
    case 'parallel'
        A = eye(N);
        isLossless = true;
    case 'series'
        A = tril(randn(N),-1)/N + eye(N);
        isLossless = false;
    case 'diagonalConjugated'   
        D = diag(randn(N,1));
        A = D\randomOrthogonal(N)*D;
        isLossless = true;
    case 'tinyRotation'
        A = tinyRotationMatrix(N,0.01,varargin{:});
        isLossless = true;
    case 'allpassInFDN'
        g = rand(1,N/2)*0.2 + 0.6;
        A = randomOrthogonal(N/2);
        A = allpassInFDN(g, A, 0*g, 0*g, 0);
        isLossless = true;
    case 'nestedAllpass'
        g = rand(1,N)*0.2 + 0.6;
        A = nestedAllpass(g);
        isLossless = false;
    case 'SchroederReverberator'
        allpassGain = rand(1,N/2)*0.2 + 0.6;
        combGain = ones(1,N/2);
        A = SchroederReverberator(allpassGain, combGain, ones(1,N/2), ones(1,N/2), 1);
        isLossless = false;
    case 'AndersonMatrix'
        A = AndersonMatrix(N,varargin{:});
        isLossless = true;
    otherwise
        error('Not defined');
end