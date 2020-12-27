function [b,c,d,X,V] = completeAllpassFDN(A, varargin)
%completeAllpassFDN - Solve the general completion problem for SISO
% Solve [A,b;c,d] [X 0; 0 1] [A,b;c,d]' =  [X 0; 0 1]
% V is the corresponding balanced system matrix (= orthogonal)
%
% see "Allpass Feedback Delay Networks", Sebastian J. Schlecht, submitted
% to IEEE TRANSACTIONS ON SIGNAL PROCESSING.
% 
% Syntax:  [b,c,d,X,V] = completeAllpassFDN(A, varargin)
%
% Inputs:
%    A - feedback matrix of size NxN
%    tol (optional) - error tolerance
%    verbose (optional) - verbose text output
%
% Outputs:
%    b - input gain matrix of size Nx1
%    c - output gain matrix of size 1xN
%    d - direct gain of size 1x1
%    X - diagonal similarity matrix for balancing
%    V - balanced FDN system matrix
%
% Example: 
%    [b,c,d,X,V] = completeAllpassFDN(seriesAllpass(randn(3,1)))
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% Tuesday, 2. June 2020 Last revision: 27. December 2020


%% Input parser
p = inputParser;
p.addParameter('tol', 10^-7, @(x) isnumeric(x));
p.addParameter('verbose', false, @(x) islogical(x));
parse(p,varargin{:});

tol = p.Results.tol;
verbose = p.Results.verbose;

N = size(A,1);

%% matrix inverse and set low values to zero for clean graph
iA = inv(A);
iA( abs(iA) < tol) = 0;

%% direct component
d = (-1)^N * det(A); % ambiguity: assume det(X) = det([A,b;c,d]) = 1

dA = diag(A) - diag(iA);
% J = (A' ~= 0) .* (A ~= 0);
F = d * (A .* A' - iA .* iA' - dA * dA');

%% Solve quadratic equations: Y.^2 .* iA - Y .* F + iA'.*d^2 .* (dA * dA')
% bP = P\b
% cP = c*P
% Y = bP * cP
% Y.^2 .* iA - Y .* O + iA'.*d^2 .* (dA * dA')

[x1, x2] = mroots(iA,-F,iA'.*d^2 .* (dA * dA') );
x1 = real(x1);
x2 = real(x2);

[bX,cX, Choice, isValid] = minRankChoiceBruteForce(x1,x2);

%% Compute diagonal similarity transform
X = diag( -(A * cX') ./ bX / d );
X(isnan(X) | abs(X)>100000) = 1; % replace missing diagonal

b = X * bX;
c = cX / X;

X = diag(diag(dlyap(A,b*b'))); % recover remaining diagonal

%% Put together: X = P*P'
PVP = [A,b;c,d];

P1 = blkdiag(sqrt(X),1);
V = P1 \ PVP * (P1);


%% verify
if verbose
    [A,b;c,d] * blkdiag(X,1) * [A,b;c,d]' -  blkdiag(X,1)
    
    V * V' - eye(size(V))
    
    iA .* (bX * cX) + (iA .* (bX * cX))' - F
    
    Y = bX * cX
    Y.^2 .* iA - Y .* F + iA'.*d^2 .* (dA * dA')
    
    
    X - A*X*A' - b*b'
    inv(X) - A'*inv(X)*A - c'*c
    c*X*c' + d*d' - 1
end
ok = 1;
