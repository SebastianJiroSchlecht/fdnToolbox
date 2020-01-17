function [b,a] = shelvingFilter( omegaC, gain, type )
% Equations (18) and (20) in
% V. Välimäki and J. Reiss, "All About Audio Equalization: Solutions and Frontiers," Applied Sciences, vol. 6, no. 5, p. 129, May 2016
%
% Author: Sebastian J Schlecht
% Date: 24.03.2017

b = ones(1,3);
a = ones(1,3);

t = tan(omegaC/2);
t2 = t^2;
g2 = gain^0.5;
g4 = gain^0.25;

b(1) = g2*t2 + sqrt(2)*t*g4 + 1;
b(2) = 2*g2*t2 - 2;
b(3) = g2*t2 - sqrt(2)*t*g4 + 1;

a(1) = g2 + sqrt(2)*t*g4 + t2;
a(2) = 2*t2 - 2*g2;
a(3) = g2 - sqrt(2)*t*g4 + t2;

b = g2*b;

switch type
    case 'low'
        
    case 'high'
        tmp = b;
        b = a * gain;
        a = tmp;
end