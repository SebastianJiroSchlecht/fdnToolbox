% Symbolic computation of the general characteristic polynomial (GCP) and
% the reversed GCP for polynomial feedback matrix. 
% 
%
% Sebastian J. Schlecht, Friday, 23 August 2019

clear; clc; close all;

rng(5)

%% Parameters
N = 2;
order = 3;
delays = ( randi([5,15],[1,N]) );
A = sym('a',[N,N,order]);
switch 'full matrix'
    case 'full matrix'
        % do nothing
    case 'diagonal matrix'
        A = A .* ( eye(N).*ones(1,1,order) ); 
    otherwise
        error('Not defined');
end

%% Symbolic GCP
syms zz;
symDelay = diag(zz.^delays);
symA = mpoly2sym(A,zz);
degreeDetA = polynomialDegree(det(subs(symA,1/zz)),zz); 

Psym = symDelay - symA;

gcpSym = expand(det(Psym) * zz^degreeDetA);
[c_GCP,t_GCP] = coeffs(gcpSym,zz);

%% Symbolic Reversed GCP
symAr = subs(symA,1/zz);
symInvA = inv(symAr);

PsymInv = symDelay - symInvA;

gcpSymRev = (-1)^N *  det(symAr) * det(PsymInv) ;
[c_Rev,t_Rev] = coeffs(gcpSymRev,zz);


%% Results
disp('Matrices are inverse')
disp(simplify(symA * subs(symInvA,1/zz)))

disp('Symbolic GCP')
disp(c_GCP)
disp(t_GCP)

disp('Reversed Symbolic GCP')
disp(fliplr(c_Rev))
disp(fliplr(subs(t_Rev,1/zz)*t_Rev(1)))


