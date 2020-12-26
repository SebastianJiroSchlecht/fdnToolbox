function pm = m2pm(A)
% matrix to principal minor
% TODO: add description

N = size(A,1);

pm = 1;

for s = 1:N
    S = nchoosek(1:N,s).';
    for d = S
       pm = [pm det(A(d,d))]; 
    end
end