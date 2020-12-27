function pm = m2pm(A)
%m2pm - compute principal minors of matrix A
%
% Syntax:  pm = m2pm(A)
%
% Inputs:
%    A - matrix of size NxN
%
% Outputs:
%    pm - principal minors in ascending size order; size N^2
%
% Example: 
%    pm = m2pm(randn(3))
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 27. December 2020; Last revision: 27. December 2020


N = size(A,1);

pm = 1; % empty pm

for s = 1:N % pm size
    S = nchoosek(1:N,s).';
    for d = S
       pm = [pm det(A(d,d))]; 
    end
end