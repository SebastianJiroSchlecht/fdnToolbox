function [A,b,c,d,U] = homogeneousAllpassFDN(G, X, varargin)
%homogeneousAllpassFDN - genereate allpass FDN with homogeneous decay
% Construct V = [A,b;c d] such V is uniallpass and A = U*G, where U is
% unitary and G is the gain matrix. X is a design parameter
%
% see "Allpass Feedback Delay Networks" by Sebastian J. Schlecht
%
% Syntax:  [A,b,c,d,U] = homogeneousAllpassFDN(G, X)
%
% Inputs:
%    G - Diagonal gain matrix
%    X - Diagonal design matrix
%
% Outputs:
%    A - Feedback matrix with A = U * G
%    b - Input gains of size Nx1
%    c - Output gains of size 1xN
%    d - Direct gains of size 1x1
%    U - Unitary matrix 
%
% Example: 
%    [A,b,c,d,U] = homogeneousAllpassFDN(diag([ 0.9685,0.9812,0.9871]),diag([0.4, 0.6,.85]))
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 16. June 2020; Last revision: 16. June 2020

%% Input parser
p = inputParser;
p.addParameter('verbose', false, @(x) islogical(x));
parse(p,varargin{:});

verbose = p.Results.verbose;

%% Initialize
N = size(G,1);

R = G^2 * X;

p = diag(X);
r = diag(R);


%% Construct orthogonal Cauchy-like matrix U
% calA = poly(p);
% calAd = polyder(calA);
% 
% calB = poly(r);
% calBd = polyder(calB);
%  
% alpha = -polyval(calA,r) ./ polyval(calBd,r); 
% beta = polyval(calB,p) ./ polyval(calAd,p); 
% 
% U = sqrt(beta*alpha.') ./ (p - r.');

K = 1 ./ (p - r.');

% inv(K) ./ K'is rank one
betaAlpha = inv(K) ./ K';
[u,s,v] = svd(betaAlpha);
beta = -sqrt(s(1,1))*v(:,1);
U = sqrt(betaAlpha') .* K;


%% contruct FDN

A = U*G;
d = (-1)^N * det(A);
b = sqrt(beta);
c = -(inv(X)*inv(A)*b*d)';

%% verify
if verbose
    U*U.'
    
    X*U - U*R
    b*b'*U
    
    [isA1, XX] = isUniallpass(A, b, c, d)
    
    delays = 2.^(0:N-1);
    [isA2, den, num] = isAllpass(A, b, c, d, delays)
end

