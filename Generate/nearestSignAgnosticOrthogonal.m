function U = nearestSignAgnosticOrthogonal(A)
%nearestSignAgnosticOrthogonal - Nearest orthogonal matrix ignoring signs
% Find matrix U with U*U^T=I which minimizes || A - |U| ||_F, where |.| is
% the element-wise absolute value. This problem is non-convex and only a
% local minimum is computed.
%
% see Schlecht, S., Habets, E. (2018). Sign-Agnostic Matrix Design for
% Spatial Artificial Reverberation with Feedback Delay Networks AES
% Conference on Spatial Reproduction
%
% Syntax:  U = nearestSignAgnosticOrthogonal(A)
%
% Inputs:
%    A - Input square matrix. Signs will be ignored.
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    U - Nearest orthogonal matrix ignoring the signs
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29. January 2020; Last revision: 29. January 2020

% TODO clean docu

%% Scale input matrix to doubly stochastic 
A = sinkhornKnopp(abs(A).^2).^0.5;

%% Init search
U = nearestOrthogonal(A);
bestError = Inf;

for it = 1:10000
    newOrthogonal = sign(randn(size(A)));
    newOrthogonal(1,:) = 1; % normalize first row and column
    newOrthogonal(:,1) = 1;
    
    B = signVariableExchange(newOrthogonal, A);
    distance = norm(A - abs(U),'fro');
    if distance < bestError
        U = B;
        bestError = distance;
    end
end






function newOrthogonal = signVariableExchange(newOrthogonal, Absolute)

Orthogonal = -newOrthogonal;

maxIter = 100;
counter = 0;
while any(sign(newOrthogonal(:)) ~= sign(Orthogonal(:)))
    counter = counter + 1;
    Orthogonal = newOrthogonal;
    A = sign(Orthogonal).*Absolute;
    [U,~,V] = svd(A);
    newOrthogonal = U*V';
    
    if(counter > maxIter)
       disp('Too many iterations')
       break; 
    end
end
