function loop = zFDNloopSimple(delays, matrix, revMatrix)
%zFDNloopSimple - Simple wrapper function for zFDNloop 
%
% Syntax: loop = zFDNloopSimple(delays, matrix, revMatrix)
%
% Inputs:
%    delays - Vector of delays in [samples]
%    matrix - (FIR) matrix of size [N,N,FIR order]
%    revMatrix (optional) - inverse (FIR) matrix [N,N,FIR order]
%
% Outputs:
%    loop - Open loop transfer function 
%
% Example: 
%    loop = zFDNStandardLoop(randi([10 30],[3 1]), randomOrthogonal(3));
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: zFDNloop
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29 December 2019; Last revision: 29 December 2019

D = zDelay( delays(:) , 'isDiagonal', true );
A = zFIR ( matrix );
Absorption = zScalar(diag(eye(numel(delays))),'isDiagonal',true);
if nargin == 3
    invA = zFIR ( revMatrix );
    loop = zFDNloop(D, Absorption, A, invA );
else
    loop = zFDNloop(D, Absorption, A);
end