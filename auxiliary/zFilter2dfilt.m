function d = zFilter2dfilt(zF)

if ismatrix(zF)
    [n,m] = size(zF);
    isDiagonal = false;
    d = dfiltMatrix(n,m,isDiagonal);
    d.filters = zF;
    
elseif isa(zF,'zFilter')
    
    if isa(zF,'zSOS')
        type = 'df2sos';
    else
        type = 'df2';
    end
    
    [n,m] = zF.size();
    d = dfiltMatrix(n,m,zF.isDiagonal);
    d.filters = dfilt.(type);
    d.filters(n,m) = dfilt.(type);
    
    for nn = 1:n
        for mm = 1:m
            switch type
                case 'df2' % TODO change structure
                    b = zF.matrix.numerator(nn,mm,:);
                    a = zF.matrix.denominator(nn,mm,:);
                    d.filters(nn,mm) = dfilt.(type)(b,a);
                case 'df2sos'
                    sos = permute(zF.sos(nn,mm,:,:), [3 4 1 2]);
                    d.filters(nn,mm) = dfilt.(type)(sos);
                otherwise    
                    error('Not defined');
            end
            
            d.filters(nn,mm).PersistentMemory = true;
        end
    end
    
else
    error('Provide a zFilter or scalar gains');
end
