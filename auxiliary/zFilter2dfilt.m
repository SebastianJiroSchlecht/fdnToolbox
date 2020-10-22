function d = zFilter2dfilt(zF)

assert(isa(zF,'zFilter'),'Provide a zFilter');

[n,m] = zF.size();

d = dfiltMatrix(n,m,zF.isDiagonal);
    

d.filters = dfilt.df2; 
d.filters(n,m) = dfilt.df2; 

for nn = 1:n
    for mm = 1:m
        b = zF.matrix.numerator(nn,mm,:);
        a = zF.matrix.denominator(nn,mm,:);
        d.filters(nn,mm) = dfilt.df2(b,a);
    end
end


