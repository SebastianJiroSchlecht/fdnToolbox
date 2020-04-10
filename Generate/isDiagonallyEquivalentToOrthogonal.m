function [isDOE,Q,D,E] = isDiagonallyEquivalentToOrthogonal(A)
% Find Q = E*A*D with E,D diagonal and Q orthogonal.
%  
% see Berman, A., Parlett, B., Plemmons, R. (1981). Diagonal Scaling to an
% Orthogonal Matrix SIAM Journal on Algebraic Discrete Methods  2(1),
% 57-65. https://dx.doi.org/10.1137/0602008
%
% Sebastian J. Schlecht, Thursday, 9 January 2020

%% Hadamard quotient
C = inv(A) ./ A.';

%% C should be rank 1
[U,S,V] = svd(C);
% U(:,1) * S(1,1) * V(:,1)' - C

D2 = U(:,1) * sqrt(S(1,1));
E2 = V(:,1)' * sqrt(S(1,1));

% normalize signs
E2 = E2 .* sign(D2)';
D2 = D2 .* sign(D2);

% D2*E2 - C
D = diag(sqrt(D2));
E = diag(sqrt(E2));

Q = E*A*D;

isDOE = isParaunitary(Q);% Q*Q' is identity