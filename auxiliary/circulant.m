function C = circulant(v, dir)
%circulant - Create circulant matrix Create circulant matrix with vector v
%as the first row. dir gives the direction of per-row rotation.
%
% Syntax:  C = circulant(v, dir)
%
% Inputs:
%    v - vector of first row, size Nx1 
%    dir - direction (1/-1) for right/left shift
%
% Outputs:
%    C - Circulatn matrix
%
% Example: 
%    C = circulant(randn(5,1), 1)
%    C = circulant(randn(4,1), -1)
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
% 10 July 2020; Last revision: 10 July 2020



v = v(:)';

switch dir
    case 1
        v2 = circshift(fliplr(v),1);
        C = toeplitz(v2,v);
    case -1
        v2 = circshift((v),1);
        C = toeplitz(v2,fliplr(v));
        C = fliplr(C);
    otherwise
        error('Not defined');
end
