function zF = convert2zFilter(m)
% Convert to zFilter if m is numeric, else just return
%
% Sebastian J. Schlecht, Friday, 23. October 2020

if isnumeric(m)
    if ismatrix(m)
        zF = zScalar(m);
    else
        zF = zFIR(m);
    end
else
    zF = m;
end