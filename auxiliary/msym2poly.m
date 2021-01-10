function P = msym2poly(A)
%msym2poly - Convert symbolic polynomial matrix to vector form of polynomial matrix
%Essentially, applies sym2poly on each matrix entry
%
% Syntax:  P = msym2poly(A)
%
% Inputs:
%    A - symbolic polynomial matrix
%
% Outputs:
%    P - vector form of polynomial matrix
%
% Example: 
%    syms z;
%    P = msym2poly([z, z^2; 1, z])
%
% Other m-files required: setSubvector
% Subfunctions: none
% MAT-files required: none
%
% See also: sym2poly
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

[maxDegree,degrees] = mpolyDegree(A);
P = zeros(size(A,1), size(A,2), maxDegree+1);

for it1 = 1:size(A,1)
    for it2 = 1:size(A,2)
        pp = sym2poly(A(it1,it2));
        l = numel(pp);
        P(it1,it2,end-l+1:end) = pp;
    end
end