function [b,c,d,P,X] = completeAllpassFDN(A, varargin)
% Solve [A,b;c,d] [P 0; 0 1] [A,b;c,d]' =  [P 0; 0 1]
% X is orthogonal
%
% Sebastian J. Schlecht, Tuesday, 2. June 2020
% TODO document

% TODO check names

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
O = d * (A .* A' - iA .* iA' - dA * dA');

%% Solve quadratic equations: Y.^2 .* iA - Y .* O + iA'.*d^2 .* (dA * dA')
% bP = P\b
% cP = c*P
% Y = bP * cP
% Y.^2 .* iA - Y .* O + iA'.*d^2 .* (dA * dA')

[x1, x2] = mroots(iA,-O,iA'.*d^2 .* (dA * dA') );
x1 = real(x1);
x2 = real(x2);

[bP,cP, Choice, isValid] = minRankChoiceBruteForce(x1,x2);

%% Compute diagonal similarity transform
P = diag( -(A * cP') ./ bP / d );
P(isnan(P) | abs(P)>100000) = 1; % replace missing diagonal

b = P * bP;
c = cP / P;

P = diag(diag(dlyap(A,b*b'))); % recover remaining diagonal

%% Put together
PXP = [A,b;c,d];

P1 = blkdiag(sqrt(P),1);
X = P1 \ PXP * (P1);


%% verify
if verbose
    [A,b;c,d] * blkdiag(P,1) * [A,b;c,d]' -  blkdiag(P,1)
    
    X * X' - eye(size(X))
    
    iA .* (bP * cP) + (iA .* (bP * cP))' - O
    
    Y = bP * cP
    Y.^2 .* iA - Y .* O + iA'.*d^2 .* (dA * dA')
    
    
    P - A*P*A' - b*b'
    inv(P) - A'*inv(P)*A - c'*c
    c*P*c' + d*d' - 1
end
ok = 1;
