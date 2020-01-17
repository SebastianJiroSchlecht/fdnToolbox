function [approximation,approximationError] = matrixDelayApproximation(matrix)
%matrixDelayApproximation - Rank 1 approximation of matrix group delay
% see Scattering in Feedback Delay Networks, IEEE TASLP submitted
%
% Syntax:  [approximation,approximationError] = matrixDelayApproximation(matrix)
%
% Inputs:
%    matrix - Filter matrix
%
% Outputs:
%    approximation - Approximation of group delay in matrix
%    approximationError - Error matrix
%
% Example: 
%    [approximation,approximationError] = matrixDelayApproximation(randn(3,3,10))
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
% 28 December 2019; Last revision: 28 December 2019

%% Find group delay of each filter in matrix
[GD,~] = mgrpdelay(matrix);
GD(isinf(GD)) = nan;
matrixDelay = mean(GD,3,'omitnan');

%% Rank 1 approximation of group delay
[gdl,gdr] = outerSumApproximation( matrixDelay );
approximation = (gdl+gdr)';

approximationError = gdr' + gdl - matrixDelay;

