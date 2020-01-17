function unit = hertz2unit(hertz, fs)
%hertz2unit - Convert frequency from cycles per second to normalized
%
% Syntax:  unit = hertz2unit(hertz, fs)
%
% Inputs:
%    hertz - Frequency in cycles per second
%    fs - Sampling frequency
%
% Outputs:
%    unit - Normalized frequency [0 - 1]
%
% Example: 
%    hertz2unit(440, 48000)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: unit2hertz
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 23 December 2019; Last revision: 23 December 2019

unit = hertz / fs * 2;