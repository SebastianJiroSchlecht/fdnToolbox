function [q,p] = negpolyder(b,a,varargin)
%negpolyder - Derivative of rational polynomial with negative exponents
% Compute derivative of rational polynomial with negative exponents
% b = b_1 z^0 + b_2 z^-1 + ... + c_k z^-k+1
% a = a_1 z^0 + a_2 z^-1 + ... + a_k z^-k+1
%
% (q/p) = (b/a)'
%
% Can be substituted with chain rule: x = z^-1 and post multiply with
% (1/z)' = -1/z^2
%
% Syntax:  [q,p] = negpolyder(b,a,varargin)
%
% Inputs:
%    b - Numerator coefficients
%    a - Denominator coefficients
%    dontTruncate (optional) - Leading zeros are not truncated
%
% Outputs:
%    q - Numerator coefficients of derivative
%    p - Denominator coefficients of derivative
%
% Example: 
%    [q,p] = negpolyder(randn(3,1),randn(5,1))
%
%
% See also: polyder
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 23. October 2020; Last revision: 23. October 2020

p = inputParser;
p.addParameter('dontTruncate',false);
parse(p,varargin{:});
dontTruncate = p.Results.dontTruncate;

%% flip for substitution x = z^-1
[q,p] = polyder( flipud(b(:)), flipud(a(:)) );

%% flip for back substitution x^-1 = z
q = fliplr(q);
p = fliplr(p);

%% multiply with -1/z^2
q =  conv(q,[0 0 -1]);

%% Restore full length if truncation is not desired
if dontTruncate
    qq = zeros(1, numel(a) + numel(b) - 1);
    pp = zeros(1, numel(a) + numel(a) - 1);
    qq(1:numel(q)) = q;
    pp(1:numel(p)) = p;
    q = qq;
    p = pp;
end

