function B = realLogOfNormalMatrix( R, tol )
%realLogOfNormalMatrix( R, tol ) - compute real logarithm of real normal
%matrix
% Algorithm is described in
% Computing real logarithm of a real matrix
% by Sherif, N., & Morsy, E., in International Journal of Algebra, 2008
%
% Syntax:  B = realLogOfNormalMatrix( R, tol )
%
% Inputs:
%    R - real normal matrix
%    tol - numerical tolerance
%
% Outputs:
%    B - real logarithm if it exists. If not a complex logarithm is
%    returned
%
% Example: 
%    realLogOfNormalMatrix( orth(randn(8)), 0.0001 )
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% International Audio Laboratories, University of Erlangen-Nuremberg
% email address: sebastian.schlecht@audiolabs-erlangen.de
% Website: sebastianjiroschlecht.com
% 6. January 2019; Last revision: 6. January 2019

if nargin < 2
   tol = 10^-6; 
end

%% get matrix size
N = size(R,1);

%% compute real logarithms (see Section 3.1)
[U,T] = schur(R,'real');

it = 1;
foundSolution = 1;
while it <= N
    if (it==N)
        if T(it,it) > 0 % single positive block
            T(it,it) = log(T(it,it));
        else % single negative block
            foundSolution = 0; break;
        end
    else
        ind = [0,1]+it;
        if T(it,it) > 0  && isdiag(T(ind,ind))
            T(it,it) = log(T(it,it)); % single positive block
        else % 2x2 block
            logT = specialLogOf2x2(T(ind,ind), tol);
            if isempty(logT)
               foundSolution = 0; break;
            else
                T(ind,ind) = logT;
                it = it+1;
            end
        end
    end
    it = it+1;
end

if foundSolution
    B = U*T*U';
else
    warning('No real solution.')
    B = logm(R);
    return;
end




function logA = specialLogOf2x2(A, tol)
% real logarithm of 2x2 matrix A
% see Lemma 2

if A(1,1) < 0 && isdiag(A) && ismembertol(A(1,1),A(2,2),tol) 
    lmbd = - A(1,1);
    logA = [ log(lmbd) pi; -pi log(lmbd)];
elseif ismembertol(A(1,1),A(2,2),tol) && ismembertol(A(2,1),-A(1,2),tol)
    a = A(1,1);
    b = A(1,2);
    ll = log( a + 1i*b );
    logA = [ real(ll) imag(ll); -imag(ll) real(ll)];
else
    logA = [];
end





