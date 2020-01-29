function bestMatrix = nearestSignAgnosticOrthogonal(A, varargin)
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
%    MaximumTrails (Optional) - Number of trails
%    Tolerance (Optional) - Convergence tolerance
%
% Outputs:
%    U - Nearest orthogonal matrix ignoring the signs
%
% Example: 
%    nearestSignAgnosticOrthogonal(orth(randn(4)),'MaximumIterations',10000)
%
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29. January 2020; Last revision: 29. January 2020

%% Input Parser
p = inputParser;
p.addParameter('MaximumTrails', 10^5, @(x) isnumeric(x) );
p.addParameter('Tolerance', eps*10^5, @(x) isnumeric(x) );
parse(p,varargin{:});

MaximumTrails = p.Results.MaximumTrails;
Tolerance = p.Results.Tolerance;
%% Scale input matrix to doubly stochastic 
A = sinkhornKnopp(abs(A).^2).^0.5;

%% Init search
bestMatrix = nearestOrthogonal(A);
bestError = Inf;

for it = 1:MaximumTrails
    
    %% Generate new normalized sign matrix
    newOrthogonal = sign(randn(size(A)));
    newOrthogonal = newOrthogonal .* newOrthogonal(1,:);
    newOrthogonal = newOrthogonal .* newOrthogonal(:,1);
    
    %% Perform optimization
    B = signVariableExchange(newOrthogonal, A);
    
    %% Evaluate
    distance = norm(A - abs(B),'fro');
    if distance < bestError
        bestMatrix = B;
        bestError = distance;
        if bestError < Tolerance
           return; % best possible found
        end
    end
end



function newOrthogonal = signVariableExchange(newOrthogonal, Absolute)
% Perform the variable exchange optimization

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
       warning('Variable exchange optimization did not converge within %d iterations', maxIter)
       break; 
    end
end
