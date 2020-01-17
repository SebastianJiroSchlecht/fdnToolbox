function [p] = generalCharPolySym(d, A)
%generalCharPolySym - compute generalized characteristic polynomial
%symbolically
% 
%
% Syntax:  p = generalCharPolySym(d,A)
%
% Inputs:
%    d - vector of delays in samples
%    A - feedback matrix, can be both scalar or polynomial matrix in z^-1
%
% Outputs:
%    p - generalized characteristic polynomial symbolical
%
% Example: 
%    generalCharPolySym([3,1],mpoly2sym(randn(2,2,3)))
% 
% See also: generalCharPoly
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019


%% Compute delay characteristic polynomial
syms z;
delays = diag( z.^d );
p = expand(det(delays - A));