function mat = constructDelayMatrix(delays)
%constructDelayMatrix - Construct FIR matrix for an array of delays
%
% Syntax:  mat = constructDelayMatrix(delays)
%
% Inputs:
%    delays - Array of delays in [samples] of size N x 1.
%
% Outputs:
%    mat - FIR delay matrix with delayed 1's on the main diagonal of size N
%    x N x max(delays)
%
% Example: 
%    mat = constructDelayMatrix([3 5 2])
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
% 27 December 2019; Last revision: 27 December 2019

N = length(delays);
len = max(delays)+1;
mat = zeros(N,N,len);

for it = 1:N
   mat(it,it,delays(it)+1) = 1; 
end

