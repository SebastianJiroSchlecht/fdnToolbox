function [b,c, choice, isValid] = minRankChoiceBruteForce(x0,x1,varargin)
%minRankChoiceBruteForce - Choose elements x0 and x1 such that it is rank-1
% The algorithm tests all possible combinations of elements to find the
% best option. Can be highly improved with spanning tree approach.
%
% Syntax:  [b,c, choice, isValid] = minRankChoiceBruteForce(x0,x1)
%
% Inputs:
%    x0 - First option matrix
%    x1 - Second option matrix
%
% Outputs:
%    b - vector such that b * c = R
%    c - vector such that b * c = R
%    choice - choice matrix such that R = x0.*(1-choice) + x1.*choice
%    isValid - there is a valid combination
%
%
%
% See also: minRankChoiceBruteForce
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 16. June 2020; Last revision: 16. June 2020

%% Input parser
p = inputParser;
p.addParameter('tol', 10^-9, @(x) isnumeric(x));
parse(p,varargin{:});

tol = p.Results.tol;

N = size(x0,1);
N2 = N^2;

%% Search all combinations
it = 1;
Choices = zeros(N2, 2^N2);
err = zeros(1, 2^N2);
l1norm = zeros(1, 2^N2);

for nn = 0:N2
    % all the combinations taken nn items at a time
    combs = combnk(1:N2,nn);
    for comb = combs.'
        choice = ones(N,N);
        choice(comb) = 0;
        
        R = choice.*x0 + (1-choice).*x1;
        
        [b,c] = lowRankApprox(R,1);
        err(it) = norm( (b * c - R), 'fro');
        l1norm(it) = norm(b,1) + norm(c,1);
        
        Choices(:,it) = choice(:);
        
        it = it+1;
    end
end

%% Select best choice
isValid = err < tol;
[~,ind] = max( l1norm .* isValid ); % maximize to avoid degenerate solutions
if all(isValid == false)
    warning('No valid solution was found. Pick lowest error solution');
    [~,ind] = min(err);
end

choice = mat(Choices(:,ind));

R = choice.*x0 + (1-choice).*x1;
[b,c] = lowRankApprox(R,1);

ok = 1;