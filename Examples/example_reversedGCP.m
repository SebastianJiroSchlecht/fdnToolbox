% Symbolic computation of the general characteristic polynomial (GCP) and
% the reversed GCP for polynomial feedback matrix. 
% 
%
% Sebastian J. Schlecht, Friday, 23 August 2019

clear; clc; close all;

rng(5)

% Parameters
N = 2;
order = 3;
delays = ( randi([5,15],[1,N]) );
A = sym('a',[N,N,order]);

syms zz;
switch 'delay filter'
    case 'full matrix'
        % do nothing
        symDelay = diag(zz.^delays);
    case 'diagonal matrix'
        A = A .* ( eye(N).*ones(1,1,order) ); 
        symDelay = diag(zz.^delays);
    case 'delay filter'
        A = A(:,:,1);
        g = sym('g',[1, N]);
        symDelay = diag(zz.^delays) + diag(g .* zz.^(delays+1));
        symInvDelay = diag(zz.^delays) + diag(g .* zz.^(delays-1));
    otherwise
        error('Not defined');
end

% Symbolic GCP

symA = mpoly2sym(A,zz);
% degreeDetA = polynomialDegree(det(subs(symA,1/zz)),zz);
degreeDetA = 0; %mpolyDegree(det(subs(symA,1/zz)),zz); % TODO hack

Psym = symDelay - symA;

gcpSym = expand(det(Psym) * zz^degreeDetA);
[c_GCP,t_GCP] = coeffs(gcpSym,zz);

% Symbolic Reversed GCP
symAr = subs(symA,1/zz);
symInvA = inv(symAr);

PsymInv = symInvDelay - symInvA;

gcpSymRev = (-1)^N *  det(symAr) * det(PsymInv) ;
[c_Rev,t_Rev] = coeffs(simplify(gcpSymRev),zz);


%% Test: Matrices are inverse
% disp(simplify(symA * subs(symInvA,1/zz)))
% assert( isAlmostZero( double(simplify(symA * subs(symInvA,1/zz))) - eye(N))  ) 

%% Test: Symbolic GCP
disp(c_GCP)
disp(t_GCP)

disp(fliplr(c_Rev))
disp(fliplr(subs(t_Rev,1/zz)*t_Rev(1)))

assert( isAlmostZero( double( c_GCP -  fliplr(c_Rev) )) )
assert( isAlmostZero( double( t_GCP -  fliplr(subs(t_Rev,1/zz)*t_Rev(1) )) ))




