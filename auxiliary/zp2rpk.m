function [r,p,k] = zp2rpk(z,p,k)
% convert zeros poles to pole residues (= partial fractions)
% TODO: only works for single poles (no repeating poles)
%
% Sebastian J. Schlecht, Thursday, 22. April 2021

assert(iscolumn(z))
assert(iscolumn(p))

%% compute the denominator
den = 1 - p./p.' ;
den = den - diag(diag(den)) + eye(size(den));

num = 1 - z./p.';

numden = num./den;


%% requires stable product, therefor it is sorted first
numdenA = sort(numden,1,'ascend','ComparisonMethod','abs');

% interleaved sorting for best numerical conditioning
numdenS = numdenA*0;
numdenS(1:2:end,:) = numdenA(1:end/2,:);
numdenS(2:2:end,:) = flip(numdenA(end/2+1:end,:),1);

r = k*prod(numdenS,1);

r = r.';

%% use an arbitary position to compute k
zz = 1; 
atzz = k*prod(1 - z./zz)./prod(1 - p./zz);
atzz2 = sum(r ./ (1 - p./zz));

k = atzz - atzz2;
