function [numerator,denominator] = dss2tfSym(m,A,b,c,d)
%dss2tfSym - From delay state-space to symbolic transfer functions 
% Similar to ss2tf, but with delays. Also, this function supports multiple
% input and output. The computation is derived from block matrix form, see:
% https://en.wikipedia.org/wiki/Determinant#Block_matrices
%
% Syntax:  [tfB,tfA] = dss2tfSym(delays,A,B,C,D)
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
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

%% denominator
denominator = generalCharPolySym(m,A);
denominator = expand(denominator);

%% numerator
syms z;
delays = diag( z.^m );
adjSym = adjoint(delays - A);

numerator = d*denominator + c*adjSym*b;
numerator = expand(numerator);
