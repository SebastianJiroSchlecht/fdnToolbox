function x = clip(x, rangeValues)
%clip - restrict values in x to a given range
% Replace values outside of rangeValues with the min and max values 
%
% Syntax:  x = clip(x, rangeValues)
%
% Inputs:
%    x - vector/matrix/tensor of any size
%    rangeValues - [min max] numerical values
%
% Outputs:
%    x - clipped vector/matrix/tensor of same size
%
% Example: 
%    x = clip(rand(10,2), [0.1 0.6])
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 10 July 2020; Last revision: 10 July 2020

x = min(max(x,rangeValues(1)),rangeValues(2));
