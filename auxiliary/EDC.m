function x = EDC(y)
%EDC - Energy decay curve by Schroeder Backward-Integration
%
% Syntax:  x = EDC(y)
%
% Inputs:
%    y - Impulse response
%
% Outputs:
%    x - Energy decay curve - Backward integrated signal on dB Scale
%
% Example: 
%    EDC( randn(1000,1) .* exp(-linspace(1,10,1000)).')
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
% 29 December 2019; Last revision: 29 December 2019


x = sqrt(cumsum(flipud(abs(y)).^2,1));
x = flipud(x);
x = mag2db(x);