function impulseResponse = ss2impz_fdn(irLen, delays, A, B, C, D, varargin)
%ss2impz_fdn - From state-space to impulse response
% Uses the standard time-domain recursion to compute the impulse response
% of the given feedback delay network (FDN).
%
% Syntax:  impulseResponse = ss2impz_fdn(irLen, delays, A, B, C, D, type)
%
% Inputs:
%    irLen - length of impulse response in samples
%    delays - delays in samples of size [1,N]
%    A - feedback matrix, scalar or polynomial of size [N,N,(order)] or TF
%    B - input gains of size [N,in]
%    C - output gains of size [out,N]
%    D - direct gains of size [out,in]
%    varargin - see processFDN
%
% Outputs:
%    impulseResponse - matrix of impulse response [irLen,out,in]
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: Friday, 17. January 2020

%% Initialize
numInput = size(B,2);

%% Create dirac pulse
input = zeros(irLen, numInput);
input(1,:) = 1;

%% Time-Domain Recursion
impulseResponse = processFDN(input, delays, A, B, C, D, varargin{:});

