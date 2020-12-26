function [A,B,C,D] = polettiAllpass(g, U)
%polettiAllpass - Create Poletti's MIMO unitary reverberator
%
% from Poletti, M. (1995). A UNITARY REVERBERATOR FOR REDUCED COLOURATION
% IN ASSISTED REVERBERATION SYSTEMS INTER-NOISE and NOISE-CON  5(), 1223 -
% 1232.
%
% Syntax:  [A,B,C,D] = polettiAllpass(g, U)
%
% Inputs:
%    g - Scalar feedback gain value
%    U - Unitary feedback matrix
%
% Outputs:
%    A - Feedback matrix
%    B - Input gains
%    C - Output gains
%    D - Direct gains
%
% Example: 
%    [A,B,C,D] = polettiAllpass(0.7, randomOrthogonal(4))
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: example_polettiAllpass
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 18. June 2020; Last revision: 18. June 2020

N = size(U,1);

B = (1+g) * eye(N);
D = g*eye(N);
C = (1-g) * U;
A = -g*U;

%% verify
% X = [A,B;C,D];
% X.* X;
% 
% delays = 2.^(0:N-1);
% [isA, P] = isUniallpass(A,B,C,D)

