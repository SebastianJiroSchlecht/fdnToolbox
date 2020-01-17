function [b,a] = bandpassFilter( omegaC, gain, Q )
% Equations (29) in
% V. Välimäki and J. Reiss, "All About Audio Equalization: Solutions and Frontiers," Applied Sciences, vol. 6, no. 5, p. 129, May 2016
%
% Author: Sebastian J Schlecht
% Date: 24.03.2017

b = ones(1,3);
a = ones(1,3);

bandWidth = omegaC / Q;
t = tan(bandWidth/2);

b(1) = sqrt(gain) + gain * t;
b(2) = -2*sqrt(gain)*cos(omegaC);
b(3) = sqrt(gain) - gain * t;

a(1) = sqrt(gain) + t;
a(2) = -2*sqrt(gain)*cos(omegaC);
a(3) = sqrt(gain) - t;