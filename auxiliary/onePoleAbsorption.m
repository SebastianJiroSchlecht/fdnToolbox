function [b,a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs)
% onePoleAbsorption - Design one-pole absorption filters according to specified T60
%
% see Jot, J. M., & Chaigne, A. (1991). Digital delay networks for
% designing artificial reverberators (pp. 1-12). Presented at the Proc.
% Audio Eng. Soc. Conv., Paris, France.
%
% Syntax:  [b,a] = onePoleAbsorption(RT_DC, RT_NY, delays, fs)
%
% Inputs:
%    RT_DC - Reverberation time in [seconds] at DC frequency
%    RT_NY - Reverberation time in [seconds] at Nyquist frequency
%    delays - Array of delay times in [samples]
%    fs - Sampling frequency
%
% Outputs:
%    b - Filter numerator of size [N,1,1]
%    a - Filter denominators of size [N,1,2]
%
% Example: 
%    [b,a] = onePoleAbsorption(2, 1, [100, 130], 48000)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 17. January 2020; Last revision: 17. January 2020

N = length(delays);

K = delays * RT602slope( RT_DC, fs );
k = db2mag(K);

alpha = RT_NY / RT_DC;
bp = K * log(10) / 80 * (1 - 1/alpha^2) * 2/3;

filterLen = 2;
a = 0.0*randn(N,1,filterLen);
a(:,1,1) = 1;
a(:,1,2) = -bp;

b = zeros(N,1);
b(:,1,1) = k.*(1-bp) ;