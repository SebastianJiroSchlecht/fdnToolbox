function loop = zDomainStandardLoop(delays, matrix, revMatrix)
%zDomainStandardLoop - Simple wrapper function for zDomainLoop 
%
% Syntax: loop = zDomainStandardLoop(delays, matrix, revMatrix)
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
%    loop = zDomainStandardLoop(randi([10 30],[3 1]), randomOrthogonal(3));
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: zDomainLoop
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29 December 2019; Last revision: 29 December 2019

D = zDomainDelay( delays );
A = zDomainMatrix ( matrix );

if nargin == 3
    invA = zDomainMatrix ( revMatrix );
    loop = zDomainLoop(D, A, invA );
else
    loop = zDomainLoop(D, A);
end