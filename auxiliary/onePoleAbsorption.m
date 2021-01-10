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

HDc = db2mag( delays * RT602slope( RT_DC, fs ) );
HNyq = db2mag( delays * RT602slope( RT_NY, fs ) );

[b,a] = designOnePoleFilter(HDc, HNyq);


function [b,a] = designOnePoleFilter(HDc, HNyq)
%designOnePoleFilter - compute one pole filter 
%
% Inputs:
%    HDc - Linear magnitude at DC of size [1, number of filters]
%    HNyq - Linear magnitude at Nyquist of size [1, number of filters]
%
% Outputs:
%    sos - sos filters of size [6 x number of filters]
%
% Example: 
%    [sos] = designOnePoleFilter(rand(1,3), rand(1,3))
%
% Author: Nils Meyer-Kahlen
% Modified: Dr.-Ing. Sebastian Jiro Schlecht, 

numFilters = numel(HDc);

r = HDc ./ HNyq; 

a1 = (1-r)./(1+r); 
b0 =  (1-a1) .* HNyq;

b(:,1,1) = b0;
a(:,1,2) = a1;
a(:,1,1) = 1;


