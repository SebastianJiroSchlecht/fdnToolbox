function ir = mcircshift(ir,matrixDelays)
% circular shift a matrix of impulse responses by samples in matrixDelays
%
% Sebastian J. Schlecht, Monday, 16 January 2023
[T,N1,N2] = size(ir);

for it1 = 1:N1
    for it2 = 1:N2
        ir(:,it1,it2) = circshift(ir(:,it1,it2), matrixDelays(it1,it2),1);
    end
end

end