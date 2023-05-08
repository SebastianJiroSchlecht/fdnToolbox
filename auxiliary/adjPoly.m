function adj = adjPoly( polynomialMatrix, var )
%adjPoly - Adjugate of a polynomial matrix
% TODO adjust
% Algorithm described in
% "Some Algorithms used in the Polynomial Toolbox for Matlab" by Didier
% Henrion , Martin Hromcik , Michael Sebek in 2000
%
% Syntax:  determinant = detPolynomial( polynomialMatrix, var )
%
% Inputs:
%    polynomialMatrix - Polynomial Matrix of size [N,N,degree]
%    var - Either 'z^1' or 'z^-1'
%
% Outputs:
%    determinant - Return determinant polynomial
%
% Example: 
%    detPolynomial( randn(4,4,16), 'z^-1' )
%    detPolynomial( constructCascadedParaunitaryMatrix(4,1) , 'z^-1' )
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 29 December 2019; Last revision: 29 December 2019


tol = -200; % in dB
[~,N,len] = size(polynomialMatrix);
fftSize = len*N;

%% computation
zeropad = cat(3, zeros(N,N,fftSize-len),  polynomialMatrix);
switch var
    case 'z^-1'
        freqMat = fft(zeropad,fftSize,3);
    case 'z^1'
        freqMat = fft(flip(zeropad,3),fftSize,3);
    otherwise
        error('Not defined');    
end


freqAdj = zeros(N,N,fftSize);
for it=1:fftSize
    freqAdj(:,:,it) = adjugate( freqMat(:,:,it) );
end

adj = ifft(freqAdj,fftSize,3);

switch var
    case 'z^-1'
        adj = adj;
    case 'z^1'
        adj = flip(adj,3);  
end

%% shorten numerically
switch var
    case 'z^-1'
%         degree = polyDegree(adj, var, tol);
%         adj = adj(1:degree+1);
    case 'z^1'
        %adj = flipud(adj);
        for it1 = 1:N
            for it2 = 1:N
                degree(it1,it2) = polyDegree(adj(it1,it2,:), var, tol);
            end
        end
        
        % shorten to max degree
        adj = adj(:,:,end-max(degree(:)):end);
end



% adj = adj(1:end-(N-1));

% %% shorten the determinant numerically
% switch var
%     case 'z^-1'
%         degree = polyDegree(adj, var, tol);
%         adj = adj(1:degree+1);
%     case 'z^1'
%         adj = flipud(adj);
%         degree = polyDegree(adj, var, tol);
%         adj = adj(end-degree:end);
% end

