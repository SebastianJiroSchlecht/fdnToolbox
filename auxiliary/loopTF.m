function P = loopTF(m,A)
% construct loop transfer function matrix P as polynomial matrix
N = numel(m);
numDims = ndims(A);
P_length = max(max(m), size(A,3));
P = zeros(N,N,P_length+1);
switch numDims
    case 2
    P(:,:,end) = -A;
    case 3
    P(:,:,end - size(A,3)+1:end) = -A;   
end
for it = 1:N
   P(it,it,end-(m(it))) = 1; 
end