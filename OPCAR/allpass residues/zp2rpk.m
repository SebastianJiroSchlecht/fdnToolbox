function [r,p,k] = zp2rpk(z,p,k)
% convert zeros poles to pole residues (= partial fractions)

assert(iscolumn(z))
assert(iscolumn(p))

% compute the denominator
den = 1 - p./p.' ;
den = den - diag(diag(den)) + eye(size(den));

num = 1 - z./p.';

numden = num./den;
% r = k*prod(numden,1);
% requires stable product, therefor it is sorted first
numdenA = sort(numden,1,'ascend','ComparisonMethod','abs');
% numdenD = sort(numden,1,'descend','ComparisonMethod','abs');
% numdenS = [numdenA(1:end/2,:); numdenD(1:end/2:end,:)];
% interleaved sorting
numdenS = numdenA*0;
numdenS(1:2:end,:) = numdenA(1:end/2,:);
numdenS(2:2:end,:) = flip(numdenA(end/2+1:end,:),1);

r = k*prod(numdenS,1);

r = r.';

% use an arbitary position to test
zz = 1; 
atzz = k*prod(1 - z./zz)./prod(1 - p./zz);
atzz2 = sum(r ./ (1 - p./zz));

k = atzz - atzz2;
ok = 1;