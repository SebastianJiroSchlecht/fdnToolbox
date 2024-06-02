function Y = skew(X)
    X = triu(X,1);
    Y = X - transpose(X);
end