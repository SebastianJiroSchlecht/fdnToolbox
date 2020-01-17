function [q,p] = negpolyder(b,a)
% Compute derivative of rational polynomial with negative exponents
% b = b_1 z^0 + b_2 z^-1 + ... + c_k z^-k+1
% a = a_1 z^0 + a_2 z^-1 + ... + a_k z^-k+1
%
% (q/p) = (b/a)' 
% 
% Can be substituted with chain rule: x = z^-1 and post multiply with
% (1/z)' = -1/z^2
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

%% flip for substitution x = z^-1
[q,p] = polyder( flipud(b(:)), flipud(a(:)) );

%% flip for back substitution x^-1 = z
q = fliplr(q);
p = fliplr(p);

%% multiply with -1/z^2
q =  conv(q,[0 0 -1]); 


