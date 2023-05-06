function [b,a] = firstOrderAbsorption(RT_DC, RT_NY, crossover_frequency, delays, fs)
% firstOrderAbsorption - Design first-order shelving absorption filters according to specified T60
%
% see   Jot, J. M. Proportional parametric equalizers - Application to
% digital reverberation and environmental audio Processing. in 1–8 (2015).
%
%
% Syntax:  [b,a] = firstOrderAbsorption(RT_DC, RT_NY, delays, fs)
%
% Inputs:
%    RT_DC - Reverberation time in [seconds] at DC frequency
%    RT_NY - Reverberation time in [seconds] at Nyquist frequency
%    crossover_frequency - TODO
%    delays - Array of delay times in [samples]
%    fs - Sampling frequency
%
% Outputs:
%    b - Filter numerator of size [N,1,1]
%    a - Filter denominators of size [N,1,2]
%
% Example: 
%    [b,a] = firstOrderAbsorption(2, 1, [100, 130], 48000)
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
% Saturday, 06 May 2023

HDc = db2mag( delays * RT602slope( RT_DC, fs ) );
HNyq = db2mag( delays * RT602slope( RT_NY, fs ) );

if crossover_frequency > fs/5 % too high cross-over frequency leads to instable filter; fs/4 is the limit
    crossover_frequency = fs/5;
end
omega = crossover_frequency / fs * 2*pi;



[b,a] = designFirstOrderShelvingFilter(HDc, HNyq, omega);


function [b,a] = designFirstOrderShelvingFilter(HDc, HNyq, omega)

numFilters = numel(HDc);

t = tan(omega);
k = HDc ./ HNyq;

r = t ./ sqrt(k);

b(:,1,1) = (t .* sqrt(k) + 1) .* HNyq;
b(:,1,2) = (t .* sqrt(k) - 1) .* HNyq;
a(:,1,2) = t ./ sqrt(k) - 1;
a(:,1,1) = t ./ sqrt(k) + 1;


