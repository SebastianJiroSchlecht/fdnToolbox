function I = eyeBatch(k,n,m)

I = zeros(k,n,m);
for it = 1:k
    I(it,:,:) = eye(n,m);
end

