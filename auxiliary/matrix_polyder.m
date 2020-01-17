function [Q,P] = matrix_polyder(B, A, var)
% Wrapper function for polynomial derivative of filter matrices
%
% Sebastian J. Schlecht, Friday, 17. January 2020
%
% B = [FIR, N, M]
% A = [FIR, N, M]
% var = {'z^1','z^-1'}
%
Q = zeros(1,size(B,2),size(B,3));
P = zeros(1,size(B,2),size(B,3));
for it1 = 1:size(B,2)
    for it2 = 1:size(B,3)
        switch var
            case 'z^1'
                [q,p] = polyder(B(:,it1,it2),A(:,it1,it2));
                Q(end-length(q)+1:end,it1,it2) = q;
                P(end-length(p)+1:end,it1,it2) = p;
            case 'z^-1'
                [q,p] = negpolyder(B(:,it1,it2),A(:,it1,it2));
                Q(1:length(q),it1,it2) = q;
                P(1:length(p),it1,it2) = p;
        end
    end
end
