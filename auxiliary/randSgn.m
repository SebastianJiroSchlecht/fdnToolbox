function r = randSgn(varargin)
%randSgn - Generate random sign (-1/+1), wrapper for randi
%
% Syntax:  r = randSgn(varargin)
%
% Inputs:
%    varargin - same as randi
%
% Outputs:
%    r - random sign value
%
% Example: 
%    r = randSgn(3)
%    r = randSgn(4,2)
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
% 28 December 2019; Last revision: 28 December 2019

r = randi([0,1],varargin{:})*2 - 1;