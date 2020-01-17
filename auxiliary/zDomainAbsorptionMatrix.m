function matrixTF = zDomainAbsorptionMatrix(feedbackMatrix, absorption_b, absorption_a)
%zDomainAbsorptionMatrix - Wrapper function for zDomainMatrix 
%
% Syntax:  matrixTF = zDomainAbsorptionMatrix(feedbackMatrix, absorption_b, absorption_a)
%
% Inputs:
%    feedbackMatrix - (FIR) matrix with size [N,N,FIR order]
%    absorption_b - Vector of filter numerators with size [N,order]
%    absorption_a - Vector of filter denominators with size [N,order]
%
% Outputs:
%    matrixTF - Matrix transfer function
%
% Example: 
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

N = size(feedbackMatrix,2);
numerator = matrixConvolution(feedbackMatrix,polydiag(absorption_b));
denominator = matrixConvolution(ones(N),polydiag(absorption_a));
matrixTF = zDomainMatrix(numerator,denominator);