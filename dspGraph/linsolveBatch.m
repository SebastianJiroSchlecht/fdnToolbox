function X = linsolveBatch(A,B)
% Solve A*X = B for matrices of size

A = permute(A,[2 3 1]);
B = permute(B,[2 3 1]);

for it = 1:size(A,3)
    X(:,:,it) = linsolve(A(:,:,it), B(:,:,it)); 
end

X = permute(X,[3 1 2]);


