function [x1, x2] = mroots(a,b,c)
%mroots - Per-matrix entry version of roots
% Compute roots of quadratic equations arranged in a matrix
% For each matrix entry: a .* x^2 + b.* x + c = 0
%
% Syntax:  [x1, x2] = mroots(a,b,c)
%
% Inputs:
%    a,b,c - Matrix Coeffcients
%
% Outputs:
%    x1,x2 - Positive/Negative determinant solution of quadratic
%
% Example: 
%    [x1, x2] = mroots(randn(3),randn(3),randn(3))
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% Tuesday, 16. June 2020; Last revision: 27. December 2020


x1 = zeros(size(a));
x2 = zeros(size(a));

% Solve quadratic equation per matrix entry
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
end