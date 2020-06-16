function [AA, bb, cc, dd] = dss2ss(m, A, b, c, d)
%dss2ss - delay state-space to standard state-space
%reproduced from Rocchesso, D., & Smith, J. O., III. (1997). Circulant and
% elliptic feedback delay networks for artificial reverberation.  IEEE
% Trans. Speech, Audio Process., 5(1), 51-63.
% http://doi.org/10.1109/89.554269
%
% Syntax:  AA = dss2ss(m, A)
%
% Inputs:
%    m - vector of delays in samples (min 3 samples)
%    A - feedback matrix
%    b - input gains (optional)
%    c - output gains (optional)
%    d - direct gains (optional)
%
% Outputs:
%    AA - state-space transition matrix
%    bb - state-space input gains (optional)
%    cc - state-space output gains (optional)
%    dd - state-space direct gains (optional)
%
% Example: 
%    dss2ss([3 4], orth(randn(2)))
%    [AA,bb,cc,dd] = dss2ss([3 4], orth(randn(2)), randn(2,1), randn(1,2), randn(1))
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

N = size(A,1);

if nargin == 2 
    b = ones(N,1);
    c = ones(1,N);
    d = ones(1,1);
end

U = [];
P = [];
R = [];

for it = 1:N
   U_j = diag( ones (m(it) - 2 - 1,1),1 );
   U = blkdiag(U,U_j);
   
   R_j = zeros( m(it) - 2, N);
   R_j(end, it) = 1;
   R = [R; R_j];
   
   P_j = zeros(N, m(it) - 2);
   P_j(it,1) = 1;
   P = [P, P_j];
end

AA = [ U, R*0, R; P, zeros(N,2*N); 0*P, A, zeros(N)];
NN = size(AA,1);

bb = zeros(NN,1);
bb((-N:-1)+end+1) = b;

cc = zeros(1,NN);
cc((-N:-1)+end+1-N) = c;

dd = d;