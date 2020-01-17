function C = circulant( v, dir)
% Create circulant matrix with v as the first row. Dir gives the direction
% 
% Sebastian J. Schlecht, Friday, 17. January 2020

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
