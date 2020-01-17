function [GD,w] = mgrpdelay(A)
% Group delay of filter matrix A for each matrix entry
%
% Sebastian J. Schlecht, Monday, 26 August 2019

[N,M,FIR] = size(A);

for itn = 1:N
    for itm = 1:M
        [GD(itn,itm,:),w] = grpdelay(squeeze(A(itn,itm,:)),1);
    end
end