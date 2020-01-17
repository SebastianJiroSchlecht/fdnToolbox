function [p,m] = generalCharPoly(d, A)
%generalCharPoly - compute generalized characteristic polynomial
% as described in Schlecht, S. J., & Habets, E. A. P. (2015). Time-varying
% feedback matrices in feedback delay networks and their application in
% artificial reverberation. J. Acoust. Soc. Amer., 138(3), 1389-1398.
% http://doi.org/10.1121/1.4928394
%
% Syntax:  p = generalCharPoly(d,A)
%
% Inputs:
%    d - vector of delays in samples with z^1 variables
%    A - feedback matrix, can be both scalar or polynomial matrix with z^1 variables 
%
% Outputs:
%    p - generalized characteristic polynomial (GCP)
%    m - z^-m offset of the GCP due to the polynomial matrix
%
% Example: 
%    generalCharPoly([3,1],orth(randn(2)))
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

ND = length(d);
N = size(A,2);

%% setup polynomial
if ismatrix(A)
    matrixType = 'scalar';
else        
    matrixType = 'polyphase';
end
m = polyDegree(detPolynomial(A,'z^-1'),'z^-1');
pLen = sum(d)+1 + m;
p = zeros(1, pLen);
p(1) = 1;

%% iterate of submatrices
for nn = 1:N
    % all the combinations taken nn items at a time
    c = combnk(1:ND,nn);
    for cc = 1:size(c,1)
       ind = c(cc,:);
       pInd = sum( d(ind) ) + 1;
       
       switch matrixType
           case 'scalar'
                dd = det(A(ind,ind));
                p(pInd) = p(pInd) + (-1)^(length(ind))*dd;
           case 'polyphase'  
                dd = detPolynomial(A(ind,ind,:),'z^-1').';
                range = 0:-1:-length(dd)+1; 
                p(pInd-range) = p(pInd-range) + (-1)^(length(ind))*dd; 
       end       
    end
end
