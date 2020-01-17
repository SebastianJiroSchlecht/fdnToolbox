function [matrix,revMatrix] = constructVelvetFeedbackMatrix( N, K, sparsity, varargin )
%constructVelvetFeedbackMatrix - Construct Velvet Parunitary FIR matrix
%Wrapper function for constructCascadedParaunitaryMatrix.
%
% Syntax:  [matrix,revMatrix] = constructVelvetFeedbackMatrix( N, K, sparsity )
%
% Inputs:
%    N - Size of the paraunitary matrix (appropriate for Hadamard matrix)
%    K - Number of cascaded stages
%    sparsity - Time-wise sparsity [1 -> Inf] = [dense -> sparse]
%
% Outputs:
%    matrix - Paraunitary matrix of size [N,N,degree]
%    revMatrix - Inverse/Reverse matrix of matrix of size [N,N,degree]
%
% Example: 
%    [matrix,revMatrix] = constructVelvetFeedbackMatrix( 4, 2, 1 )
%    [matrix,revMatrix] = constructVelvetFeedbackMatrix( 8, 3, 2.5 )
%
% Other m-files required: constructCascadedParaunitaryMatrix
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Dr.-Ing. Sebastian Jiro Schlecht, 
% Aalto University, Finland
% email address: sebastian.schlecht@aalto.fi
% Website: sebastianjiroschlecht.com
% 28 December 2019; Last revision: 28 December 2019

[matrix,revMatrix] = constructCascadedParaunitaryMatrix( N, K, 'sparsity', sparsity, 'matrixType', 'Hadamard', varargin{:} );









