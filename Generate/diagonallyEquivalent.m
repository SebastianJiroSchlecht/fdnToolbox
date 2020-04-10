function B = diagonallyEquivalent(A,D,E)
% Computes B = D * A * E for a diagonal matrix D. For D = inv(E), if A is
% lossless if and only if B is lossless. See Schlecht, S., Habets, E.
% (2017). On lossless feedback delay networks IEEE Trans. Signal Process.
% 65(6), 1554 - 1564. https://dx.doi.org/10.1109/tsp.2016.2637323
%
% Sebastian J. Schlecht, Friday, 10. April 2020

if isDiag(D) && isDiag(E)
    B = D * A * E;
else
    warning('D or E is not diagonal.');
end
