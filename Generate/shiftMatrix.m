function mat = shiftMatrix(mat, shift, direction)
% Shift in polynomial matrix in time-domain by shift samples 
% direction is either 'left' or 'right'
%
% Sebastian J. Schlecht, Sunday, 29 December 2019

N = size(mat,1);

%% Secure enough space
pp = find_ndim(mat,3,'last');

%% Time Shift
switch direction
    case 'left'
        requiredSpace = pp + shift';
        additionalSpace = max(requiredSpace(:)) - size(mat,3);
        mat = cat(3,mat,zeros(N,N,additionalSpace));
        for it = 1:N
            mat( it, :, :) = circshift( mat( it, :, :), shift(it), 3 );
        end
    case 'right'
        requiredSpace = pp + shift;
        additionalSpace = max(requiredSpace(:)) - size(mat,3);
        mat = cat(3,mat,zeros(N,N,additionalSpace));
        for it = 1:N
            mat( :, it, :) = circshift( mat( :, it, :), shift(it), 3 );
        end
    otherwise
        error('Not defined direction');
end
