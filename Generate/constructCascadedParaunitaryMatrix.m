function [matrix,revMatrix] = constructCascadedParaunitaryMatrix( N, K, varargin )
%constructCascadedParaunitaryMatrix - Create paraunitary matrix from
%cascaded design
% see Scattering in Feedback Delay Networks, IEEE TASLP submitted
%
% Syntax:  matrix = constructCascadedParaunitaryMatrix( N, K )
%
% Inputs:
%    N - Size of the paraunitary matrix
%    K - Number of cascaded stages
%    sparsity (optional) - Time-wise sparsity [1 -> Inf] = [dense -> sparse]
%    matrixType (optional) - Random or Hadamard matrix
%
% Outputs:
%    matrix - Paraunitary matrix of size [N,N,degree]
%    revMatrix - Inverse/Reverse matrix of matrix of size [N,N,degree]
%
% Example:
%    constructCascadedParaunitaryMatrix( 3, 5 )
%
% See also: isParaunitary
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019


%% Input parser
p = inputParser;
p.addOptional('sparsity', 1, @(x) isnumeric(x) && isscalar(x) && x >= 1 );
p.addOptional('matrixType','Hadamard',@(x) ischar(x) );
p.addOptional('gainPerSample', 1, @(x) isnumeric(x) && isscalar(x) && x >= 0 );
parse(p,varargin{:});

sparsity = p.Results.sparsity;
matrixType = p.Results.matrixType;
gainPerSample = p.Results.gainPerSample;

%% init matrix function
switch matrixType
    case 'Hadamard'
        generateMatrix = @(x) hadamard(x)/sqrt(x);
    case 'random' 
        generateMatrix = @(x) randomOrthogonal(x);  
    otherwise 
        error('Matrix type not defined');
end
    
sparsityVector = [sparsity, ones(1,K-1)];

%% construct paraunitary matrix
matrix = generateMatrix(N);
revMatrix = inv(matrix);

pulseSize = 1;
for it = 1:K
    
    [shiftLeft] = shiftMatrixDistribute(matrix, sparsityVector(it), 'pulseSize', pulseSize);
    
    G1 = diag(gainPerSample.^shiftLeft);
    R1 = generateMatrix(N) * G1;

    matrix = shiftMatrix(matrix, shiftLeft, 'left');
    matrix = matrixConvolution(R1, matrix);
    
    revMatrix = shiftMatrix(revMatrix, shiftLeft, 'right');
    revMatrix = matrixConvolution(revMatrix, inv(R1));
   
    pulseSize = pulseSize * N*sparsityVector(it);
end
















