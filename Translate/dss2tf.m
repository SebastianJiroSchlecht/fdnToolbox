function [tfB,tfA] = dss2tf(delays,A,B,C,D)
%dss2tf - From state-space to transfer functions
% Similar to ss2tf, but with delays. Also, this function supports multiple
% input and output. The computation is derived from block matrix form, see:
% https://en.wikipedia.org/wiki/Determinant#Block_matrices
%
% Syntax:  [tfB,tfA] = dss2tf(delays,A,B,C,D)
%
% Inputs:
%    delays - delays in samples of size [1,N]
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)]
%    B - input gains of size [N,in]
%    C - output gains of size [out,N]
%    D - direct gains of size [out,in]
%
% Outputs:
%    tfB - numerator of transfer function matrix of size [out,in,order]
%    tfA - denominator of transfer function matrix of size [1,order]
%
%
% See also: example_ss2tf_fdn
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

tfA = generalCharPoly(delays,A);

numInput = size(B,2);
numOutput = size(C,1);

for itOut = 1:numOutput
    for itIn = 1:numInput
       tfB(itOut,itIn,:) = numerator(delays,A,B(:,itIn),C(itOut,:),D(itOut,itIn), tfA);
    end
end

function tfB = numerator(delays,A,b,c,d, tfA)
switch ndims(A)
    case 2
        tfB = (d+1)*tfA - generalCharPoly(delays,A+b*c);
    case 3
        A(1,:,:) = squeeze(A(1,:,:)) - b*c;
        tfB = generalCharPoly(delays,A);
end

