function [isA, den, num] = isAllpass(A,b,c,d,m,varargin)
%isAllpass - Test delay state-space is allpass
%Computes the determinant rational transfer function and determines whether the
%numerator is a reversed version of the denominator.
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
%
% Syntax:  [isA, den, num] = isAllpass(A,b,c,d,m,varargin)
%
% Inputs:
%    A - Feedback matrix
%    b - Input gains
%    c - Output gains
%    d - Direct gain
%    m - Delay lengths
%
% Outputs:
%    isA - Logical values whether is allpass
%    den - Transfer function denominator
%    num - Transfer function numerator 
%
% Example: 
%    see example_polettiAllpass.m
%
% Other m-files required: generalCharPoly
% Subfunctions: none
% MAT-files required: none
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 18. June 2020; Last revision: 18. June 2020

den = generalCharPoly(m, A);
num = generalCharPoly(m, A - b*inv(d)*c) * (det(d));

%% normalize the sign
[isA,maxVal] = isAlmostZero(fliplr(den) - num * sign(num(end)), varargin{:});