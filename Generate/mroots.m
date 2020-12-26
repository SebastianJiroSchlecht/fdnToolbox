function [x1, x2] = mroots(a,b,c)
% Compute roots of quadratic equations arranged in a matrix
% For each matrix entry: a .* x^2 + b.* x + c = 0
%
% Sebastian J. Schlecht, Tuesday, 16. June 2020

% TODO make more general

x1 = zeros(size(a));
x2 = zeros(size(a));

rr = zeros([size(a),2]);

for it = 1:numel(x1)
    r = roots([a(it),b(it),c(it)]);
    
    if( numel(r) == 0 )
        
    elseif( numel(r) == 1 )
        x1(it) = r(1);
        x2(it) = r(1);
    else
        x1(it) = r(1);
        x2(it) = r(2);
    end
    ok = 1;
end